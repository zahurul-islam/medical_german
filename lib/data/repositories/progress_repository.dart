/// Progress repository for tracking user learning progress
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class ProgressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get progress for a specific section
  Future<ProgressModel?> getSectionProgress({
    required String userId,
    required String sectionId,
  }) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(sectionId)
        .get();

    if (doc.exists) {
      return ProgressModel.fromFirestore(doc);
    }
    return null;
  }

  /// Get all progress for a user
  Future<List<ProgressModel>> getAllProgress(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .get();

    return snapshot.docs
        .map((doc) => ProgressModel.fromFirestore(doc))
        .toList();
  }

  /// Get progress by phase
  Future<List<ProgressModel>> getProgressByPhase({
    required String userId,
    required List<String> sectionIds,
  }) async {
    if (sectionIds.isEmpty) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .where(FieldPath.documentId, whereIn: sectionIds)
        .get();

    return snapshot.docs
        .map((doc) => ProgressModel.fromFirestore(doc))
        .toList();
  }

  /// Start a section (create progress entry)
  Future<ProgressModel> startSection({
    required String userId,
    required String sectionId,
    int vocabularyTotal = 0,
    int dialoguesTotal = 0,
    int exercisesTotal = 0,
  }) async {
    final now = DateTime.now();
    final progress = ProgressModel(
      id: sectionId,
      sectionId: sectionId,
      userId: userId,
      completed: false,
      percentComplete: 0.0,
      startedAt: now,
      lastAccessedAt: now,
      vocabularyTotal: vocabularyTotal,
      dialoguesTotal: dialoguesTotal,
      exercisesTotal: exercisesTotal,
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(sectionId)
        .set(progress.toFirestore());

    return progress;
  }

  /// Update progress
  Future<void> updateProgress({
    required String userId,
    required String sectionId,
    int? vocabularyMastered,
    int? dialoguesWatched,
    int? exercisesCompleted,
    Map<String, int>? exerciseScores,
    int? totalPoints,
  }) async {
    final updates = <String, dynamic>{
      'lastAccessedAt': FieldValue.serverTimestamp(),
    };

    if (vocabularyMastered != null) {
      updates['vocabularyMastered'] = vocabularyMastered;
    }
    if (dialoguesWatched != null) {
      updates['dialoguesWatched'] = dialoguesWatched;
    }
    if (exercisesCompleted != null) {
      updates['exercisesCompleted'] = exercisesCompleted;
    }
    if (exerciseScores != null) {
      updates['exerciseScores'] = exerciseScores;
    }
    if (totalPoints != null) {
      updates['totalPoints'] = totalPoints;
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(sectionId)
        .update(updates);

    // Recalculate percent complete
    await _recalculatePercentComplete(userId, sectionId);
  }

  /// Mark vocabulary as mastered
  Future<void> markVocabularyMastered({
    required String userId,
    required String sectionId,
    required int count,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(sectionId)
        .update({
      'vocabularyMastered': FieldValue.increment(count),
      'lastAccessedAt': FieldValue.serverTimestamp(),
    });

    await _recalculatePercentComplete(userId, sectionId);
  }

  /// Mark dialogue as watched
  Future<void> markDialogueWatched({
    required String userId,
    required String sectionId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(sectionId)
        .update({
      'dialoguesWatched': FieldValue.increment(1),
      'lastAccessedAt': FieldValue.serverTimestamp(),
    });

    await _recalculatePercentComplete(userId, sectionId);
  }

  /// Record exercise result
  Future<void> recordExerciseResult({
    required String userId,
    required String sectionId,
    required String exerciseId,
    required int score,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(sectionId);

    final doc = await docRef.get();
    if (doc.exists) {
      final data = doc.data()!;
      final exerciseScores = Map<String, int>.from(data['exerciseScores'] ?? {});
      
      // Only count as new completion if not previously completed
      final isNewCompletion = !exerciseScores.containsKey(exerciseId);
      
      exerciseScores[exerciseId] = score;
      
      await docRef.update({
        'exerciseScores': exerciseScores,
        'totalPoints': FieldValue.increment(score),
        if (isNewCompletion) 'exercisesCompleted': FieldValue.increment(1),
        'lastAccessedAt': FieldValue.serverTimestamp(),
      });

      await _recalculatePercentComplete(userId, sectionId);
    }
  }

  /// Complete a section
  Future<void> completeSection({
    required String userId,
    required String sectionId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(sectionId)
        .update({
      'completed': true,
      'completedAt': FieldValue.serverTimestamp(),
      'percentComplete': 100.0,
      'lastAccessedAt': FieldValue.serverTimestamp(),
    });

    // Update user stats
    await _updateUserStats(userId);
  }

  /// Get user statistics
  Future<UserStatsModel> getUserStats(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final progressDocs = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .get();

    int completed = 0;
    int totalPoints = 0;

    for (final doc in progressDocs.docs) {
      final data = doc.data();
      if (data['completed'] == true) completed++;
      totalPoints += (data['totalPoints'] as int?) ?? 0;
    }

    final userData = userDoc.data() ?? {};

    return UserStatsModel(
      totalSectionsCompleted: completed,
      totalSections: 55, // Total sections in the app
      totalPoints: totalPoints,
      streak: userData['streak'] ?? 0,
      totalMinutesLearned: userData['totalMinutesLearned'] ?? 0,
      currentLevel: userData['currentLevel'] ?? 'A1',
      levelProgress: Map<String, int>.from(userData['levelProgress'] ?? {}),
    );
  }

  /// Get recently accessed sections
  Future<List<ProgressModel>> getRecentSections({
    required String userId,
    int limit = 5,
  }) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .orderBy('lastAccessedAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => ProgressModel.fromFirestore(doc))
        .toList();
  }

  // Private helper methods

  Future<void> _recalculatePercentComplete(
    String userId,
    String sectionId,
  ) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(sectionId)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;
    final vocabMastered = data['vocabularyMastered'] ?? 0;
    final vocabTotal = data['vocabularyTotal'] ?? 0;
    final dialoguesWatched = data['dialoguesWatched'] ?? 0;
    final dialoguesTotal = data['dialoguesTotal'] ?? 0;
    final exercisesCompleted = data['exercisesCompleted'] ?? 0;
    final exercisesTotal = data['exercisesTotal'] ?? 0;

    double percent = 0.0;
    int totalItems = 0;
    int completedItems = 0;

    if (vocabTotal > 0) {
      totalItems += vocabTotal as int;
      completedItems += vocabMastered as int;
    }
    if (dialoguesTotal > 0) {
      totalItems += dialoguesTotal as int;
      completedItems += dialoguesWatched as int;
    }
    if (exercisesTotal > 0) {
      totalItems += exercisesTotal as int;
      completedItems += exercisesCompleted as int;
    }

    if (totalItems > 0) {
      percent = (completedItems / totalItems) * 100;
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(sectionId)
        .update({'percentComplete': percent});
  }

  Future<void> _updateUserStats(String userId) async {
    final progressDocs = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .where('completed', isEqualTo: true)
        .get();

    final completedCount = progressDocs.docs.length;

    // Determine new level based on completed sections
    String newLevel = 'A1';
    if (completedCount >= 45) {
      newLevel = 'C1';
    } else if (completedCount >= 29) {
      newLevel = 'B2';
    } else if (completedCount >= 17) {
      newLevel = 'B1';
    } else if (completedCount >= 8) {
      newLevel = 'A2';
    }

    await _firestore.collection('users').doc(userId).update({
      'currentLevel': newLevel,
    });
  }
}
