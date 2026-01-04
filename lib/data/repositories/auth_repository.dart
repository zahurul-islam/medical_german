// Authentication repository for Firebase Auth
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user_model.dart';

/// Result class for authentication operations
class AuthResult {
  final User user;
  final bool isNewUser;
  final bool hasAcceptedTerms;

  AuthResult({
    required this.user,
    required this.isNewUser,
    required this.hasAcceptedTerms,
  });
}

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Server client ID (web) is required for Android to get idToken
    serverClientId: '149956547132-oh0rbe3aer37vc8aedlda7ph0bftf9dp.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _updateLastLogin(credential.user!.uid);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Register with email only (sends verification link)
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String sourceLanguage = 'en',
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await credential.user!.sendEmailVerification();

      // Create user document in Firestore
      await _createUserDocument(
        userId: credential.user!.uid,
        email: email,
        sourceLanguage: sourceLanguage,
        authMethod: AuthMethod.email,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Send email verification link
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Check if email is verified
  Future<bool> checkEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    // Reload user to get latest verification status
    await user.reload();
    final refreshedUser = _auth.currentUser;

    if (refreshedUser?.emailVerified == true) {
      // Update Firestore
      await _firestore.collection('users').doc(refreshedUser!.uid).update({
        'isEmailVerified': true,
      });
      return true;
    }
    return false;
  }

  /// Accept terms and conditions
  Future<void> acceptTermsAndConditions() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    await _firestore.collection('users').doc(user.uid).update({
      'hasAcceptedTerms': true,
      'termsAcceptedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Check if user has accepted terms
  Future<bool> hasAcceptedTerms() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return false;

    return doc.data()?['hasAcceptedTerms'] ?? false;
  }

  /// Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      // Create or update user document and check if new user
      final result = await _createOrUpdateUserDocument(
        userCredential.user!,
        authMethod: AuthMethod.google,
      );

      return AuthResult(
        user: userCredential.user!,
        isNewUser: result['isNewUser'] as bool,
        hasAcceptedTerms: result['hasAcceptedTerms'] as bool,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      // Handle Google Sign-In specific errors
      if (e.toString().contains('sign_in_canceled')) {
        throw Exception('Google sign-in was cancelled');
      } else if (e.toString().contains('network_error')) {
        throw Exception('Network error. Please check your connection.');
      } else if (e.toString().contains('sign_in_failed')) {
        throw Exception('Google sign-in failed. Please try again.');
      }
      rethrow;
    }
  }

  /// Sign in with Apple
  Future<AuthResult> signInWithApple() async {
    try {
      // Generate nonce for security
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request Apple sign-in
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Verify we got an identity token
      if (appleCredential.identityToken == null) {
        throw Exception('Apple Sign-In failed: No identity token received');
      }

      // Create OAuth credential for Firebase
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken!,
        rawNonce: rawNonce,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      // Update display name if provided by Apple (only on first sign-in)
      String? displayName;
      if (appleCredential.givenName != null || appleCredential.familyName != null) {
        displayName = [
          appleCredential.givenName,
          appleCredential.familyName,
        ].where((name) => name != null).join(' ');

        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
        }
      }

      // Create or update user document
      final result = await _createOrUpdateUserDocument(
        userCredential.user!,
        authMethod: AuthMethod.apple,
        displayName: displayName,
      );

      return AuthResult(
        user: userCredential.user!,
        isNewUser: result['isNewUser'] as bool,
        hasAcceptedTerms: result['hasAcceptedTerms'] as bool,
      );
    } on FirebaseAuthException catch (e) {
      // More detailed Firebase error for Apple Sign-In
      if (e.code == 'invalid-credential') {
        throw Exception('Apple Sign-In failed: Invalid credential. Please check Firebase Apple configuration.');
      }
      throw _handleAuthException(e);
    } on SignInWithAppleAuthorizationException catch (e) {
      // Handle Apple Sign-In specific errors
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          throw Exception('Apple sign-in was cancelled');
        case AuthorizationErrorCode.failed:
          throw Exception('Apple sign-in failed. Please try again.');
        case AuthorizationErrorCode.invalidResponse:
          throw Exception('Invalid response from Apple. Please try again.');
        case AuthorizationErrorCode.notHandled:
          throw Exception('Apple sign-in request not handled.');
        case AuthorizationErrorCode.notInteractive:
          throw Exception('Apple sign-in requires user interaction.');
        case AuthorizationErrorCode.unknown:
          throw Exception('Apple sign-in error: ${e.message}');
      }
    } catch (e) {
      // Capture the actual error message for debugging
      final errorMsg = e.toString();
      if (errorMsg.contains('invalid-credential') || errorMsg.contains('Invalid OAuth')) {
        throw Exception('Invalid OAuth response from apple.com');
      }
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Get user model from Firestore
  Future<UserModel?> getUserModel(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? sourceLanguage,
    String? currentLevel,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['displayName'] = displayName;
    if (sourceLanguage != null) updates['sourceLanguage'] = sourceLanguage;
    if (currentLevel != null) updates['currentLevel'] = currentLevel;

    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(userId).update(updates);
    }
  }

  // Private helper methods

  Future<void> _createUserDocument({
    required String userId,
    required String email,
    String sourceLanguage = 'en',
    AuthMethod authMethod = AuthMethod.email,
  }) async {
    final user = UserModel(
      id: userId,
      email: email,
      sourceLanguage: sourceLanguage,
      currentLevel: 'A1',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      authMethod: authMethod,
      hasAcceptedTerms: false,
      isEmailVerified: false,
    );

    await _firestore.collection('users').doc(userId).set(user.toFirestore());
  }

  /// Creates or updates user document and returns status flags
  Future<Map<String, dynamic>> _createOrUpdateUserDocument(
    User user, {
    required AuthMethod authMethod,
    String? displayName,
  }) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      // New user - create document
      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: displayName ?? user.displayName,
        photoUrl: user.photoURL,
        sourceLanguage: 'en',
        currentLevel: 'A1',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        authMethod: authMethod,
        hasAcceptedTerms: false,
        isEmailVerified: authMethod != AuthMethod.email, // Social logins are pre-verified
      );
      await docRef.set(userModel.toFirestore());
      return {
        'isNewUser': true,
        'hasAcceptedTerms': false,
      };
    } else {
      // Existing user - update last login and return current status
      await _updateLastLogin(user.uid);
      final data = doc.data() as Map<String, dynamic>;
      return {
        'isNewUser': false,
        'hasAcceptedTerms': data['hasAcceptedTerms'] ?? false,
      };
    }
  }

  Future<void> _updateLastLogin(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email.';
        break;
      case 'wrong-password':
        message = 'Incorrect password.';
        break;
      case 'email-already-in-use':
        message = 'An account with this email already exists.';
        break;
      case 'weak-password':
        message = 'The password is too weak.';
        break;
      case 'invalid-email':
        message = 'The email address is invalid.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please try again later.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your connection.';
        break;
      default:
        message = e.message ?? 'An error occurred. Please try again.';
    }
    return Exception(message);
  }
}
