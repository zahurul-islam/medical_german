/// User model for MedDeutsch
import 'package:cloud_firestore/cloud_firestore.dart';

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
      settings: settings ?? this.settings,
    );
  }
}
