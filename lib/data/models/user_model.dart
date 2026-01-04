/// User model for MedDeutsch
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthMethod { email, google, apple }

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String sourceLanguage; // en, bn, hi, ur, tr
  final String currentLevel; // A1, A2, B1, B2, C1
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isPremium;
  final bool hasAcceptedTerms;
  final DateTime? termsAcceptedAt;
  final bool isEmailVerified;
  final AuthMethod authMethod;
  final Map<String, dynamic>? settings;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.sourceLanguage = 'en',
    this.currentLevel = 'A1',
    required this.createdAt,
    required this.lastLoginAt,
    this.isPremium = false,
    this.hasAcceptedTerms = false,
    this.termsAcceptedAt,
    this.isEmailVerified = false,
    this.authMethod = AuthMethod.email,
    this.settings,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      sourceLanguage: data['sourceLanguage'] ?? 'en',
      currentLevel: data['currentLevel'] ?? 'A1',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPremium: data['isPremium'] ?? false,
      hasAcceptedTerms: data['hasAcceptedTerms'] ?? false,
      termsAcceptedAt: (data['termsAcceptedAt'] as Timestamp?)?.toDate(),
      isEmailVerified: data['isEmailVerified'] ?? false,
      authMethod: AuthMethod.values.firstWhere(
        (e) => e.name == (data['authMethod'] ?? 'email'),
        orElse: () => AuthMethod.email,
      ),
      settings: data['settings'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'sourceLanguage': sourceLanguage,
      'currentLevel': currentLevel,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'isPremium': isPremium,
      'hasAcceptedTerms': hasAcceptedTerms,
      'termsAcceptedAt': termsAcceptedAt != null ? Timestamp.fromDate(termsAcceptedAt!) : null,
      'isEmailVerified': isEmailVerified,
      'authMethod': authMethod.name,
      'settings': settings,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? sourceLanguage,
    String? currentLevel,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isPremium,
    bool? hasAcceptedTerms,
    DateTime? termsAcceptedAt,
    bool? isEmailVerified,
    AuthMethod? authMethod,
    Map<String, dynamic>? settings,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      currentLevel: currentLevel ?? this.currentLevel,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isPremium: isPremium ?? this.isPremium,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      termsAcceptedAt: termsAcceptedAt ?? this.termsAcceptedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      authMethod: authMethod ?? this.authMethod,
      settings: settings ?? this.settings,
    );
  }
}
