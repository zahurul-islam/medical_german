/// Progress model for tracking user learning progress
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel {
  final String id;
  final String sectionId;
  final String userId;
  final bool completed;
  final double percentComplete;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime lastAccessedAt;
  final int vocabularyMastered;
  final int vocabularyTotal;
  final int dialoguesWatched;
  final int dialoguesTotal;
  final int exercisesCompleted;
  final int exercisesTotal;
  final int totalPoints;
  final Map<String, int> exerciseScores; // exerciseId -> score

  ProgressModel({
    required this.id,
    required this.sectionId,
    required this.userId,
    this.completed = false,
    this.percentComplete = 0.0,
    this.startedAt,
    this.completedAt,
    required this.lastAccessedAt,
    this.vocabularyMastered = 0,
    this.vocabularyTotal = 0,
    this.dialoguesWatched = 0,
    this.dialoguesTotal = 0,
    this.exercisesCompleted = 0,
    this.exercisesTotal = 0,
    this.totalPoints = 0,
    this.exerciseScores = const {},
  });

  double get vocabularyProgress {
    if (vocabularyTotal == 0) return 0.0;
    return vocabularyMastered / vocabularyTotal;
  }

  double get dialogueProgress {
    if (dialoguesTotal == 0) return 0.0;
    return dialoguesWatched / dialoguesTotal;
  }

  double get exerciseProgress {
    if (exercisesTotal == 0) return 0.0;
    return exercisesCompleted / exercisesTotal;
  }

  factory ProgressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProgressModel(
      id: doc.id,
      sectionId: data['sectionId'] ?? '',
      userId: data['userId'] ?? '',
      completed: data['completed'] ?? false,
      percentComplete: (data['percentComplete'] ?? 0.0).toDouble(),
      startedAt: (data['startedAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      lastAccessedAt: (data['lastAccessedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      vocabularyMastered: data['vocabularyMastered'] ?? 0,
      vocabularyTotal: data['vocabularyTotal'] ?? 0,
      dialoguesWatched: data['dialoguesWatched'] ?? 0,
      dialoguesTotal: data['dialoguesTotal'] ?? 0,
      exercisesCompleted: data['exercisesCompleted'] ?? 0,
      exercisesTotal: data['exercisesTotal'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
      exerciseScores: Map<String, int>.from(data['exerciseScores'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sectionId': sectionId,
      'userId': userId,
      'completed': completed,
      'percentComplete': percentComplete,
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'lastAccessedAt': Timestamp.fromDate(lastAccessedAt),
      'vocabularyMastered': vocabularyMastered,
      'vocabularyTotal': vocabularyTotal,
      'dialoguesWatched': dialoguesWatched,
      'dialoguesTotal': dialoguesTotal,
      'exercisesCompleted': exercisesCompleted,
      'exercisesTotal': exercisesTotal,
      'totalPoints': totalPoints,
      'exerciseScores': exerciseScores,
    };
  }

  ProgressModel copyWith({
    String? id,
    String? sectionId,
    String? userId,
    bool? completed,
    double? percentComplete,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? lastAccessedAt,
    int? vocabularyMastered,
    int? vocabularyTotal,
    int? dialoguesWatched,
    int? dialoguesTotal,
    int? exercisesCompleted,
    int? exercisesTotal,
    int? totalPoints,
    Map<String, int>? exerciseScores,
  }) {
    return ProgressModel(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      userId: userId ?? this.userId,
      completed: completed ?? this.completed,
      percentComplete: percentComplete ?? this.percentComplete,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      vocabularyMastered: vocabularyMastered ?? this.vocabularyMastered,
      vocabularyTotal: vocabularyTotal ?? this.vocabularyTotal,
      dialoguesWatched: dialoguesWatched ?? this.dialoguesWatched,
      dialoguesTotal: dialoguesTotal ?? this.dialoguesTotal,
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
      exercisesTotal: exercisesTotal ?? this.exercisesTotal,
      totalPoints: totalPoints ?? this.totalPoints,
      exerciseScores: exerciseScores ?? this.exerciseScores,
    );
  }
}

/// Overall user statistics
class UserStatsModel {
  final int totalSectionsCompleted;
  final int totalSections;
  final int totalPoints;
  final int streak; // Days of consecutive learning
  final int totalMinutesLearned;
  final String currentLevel;
  final Map<String, int> levelProgress; // A1: 100, A2: 50, etc.

  UserStatsModel({
    this.totalSectionsCompleted = 0,
    this.totalSections = 55,
    this.totalPoints = 0,
    this.streak = 0,
    this.totalMinutesLearned = 0,
    this.currentLevel = 'A1',
    this.levelProgress = const {},
  });

  double get overallProgress {
    if (totalSections == 0) return 0.0;
    return totalSectionsCompleted / totalSections;
  }

  factory UserStatsModel.fromFirestore(Map<String, dynamic> data) {
    return UserStatsModel(
      totalSectionsCompleted: data['totalSectionsCompleted'] ?? 0,
      totalSections: data['totalSections'] ?? 55,
      totalPoints: data['totalPoints'] ?? 0,
      streak: data['streak'] ?? 0,
      totalMinutesLearned: data['totalMinutesLearned'] ?? 0,
      currentLevel: data['currentLevel'] ?? 'A1',
      levelProgress: Map<String, int>.from(data['levelProgress'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalSectionsCompleted': totalSectionsCompleted,
      'totalSections': totalSections,
      'totalPoints': totalPoints,
      'streak': streak,
      'totalMinutesLearned': totalMinutesLearned,
      'currentLevel': currentLevel,
      'levelProgress': levelProgress,
    };
  }
}
