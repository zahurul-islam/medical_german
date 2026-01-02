/// Content repository for fetching learning content from Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class ContentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache for frequently accessed data
  List<PhaseModel>? _phasesCache;
  final Map<String, List<SectionModel>> _sectionsCache = {};

  /// Get all learning phases
  Future<List<PhaseModel>> getPhases() async {
    if (_phasesCache != null) {
      return _phasesCache!;
    }

    final snapshot = await _firestore
        .collection('phases')
        .orderBy('order')
        .get();

    _phasesCache = snapshot.docs
        .map((doc) => PhaseModel.fromFirestore(doc))
        .toList();

    return _phasesCache!;
  }

  /// Get sections for a specific phase
  Future<List<SectionModel>> getSectionsByPhase(String phaseId) async {
    if (_sectionsCache.containsKey(phaseId)) {
      return _sectionsCache[phaseId]!;
    }

    final snapshot = await _firestore
        .collection('sections')
        .where('phaseId', isEqualTo: phaseId)
        .orderBy('order')
        .get();

    final sections = snapshot.docs
        .map((doc) => SectionModel.fromFirestore(doc))
        .toList();

    _sectionsCache[phaseId] = sections;
    return sections;
  }

  /// Get all sections
  Future<List<SectionModel>> getAllSections() async {
    final snapshot = await _firestore
        .collection('sections')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => SectionModel.fromFirestore(doc))
        .toList();
  }

  /// Get a specific section by ID
  Future<SectionModel?> getSection(String sectionId) async {
    final doc = await _firestore
        .collection('sections')
        .doc(sectionId)
        .get();

    if (doc.exists) {
      return SectionModel.fromFirestore(doc);
    }
    return null;
  }

  /// Get vocabulary for a section
  Future<List<VocabularyModel>> getVocabulary(String sectionId) async {
    final snapshot = await _firestore
        .collection('sections')
        .doc(sectionId)
        .collection('vocabulary')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => VocabularyModel.fromFirestore(doc))
        .toList();
  }

  /// Get dialogues for a section
  Future<List<DialogueModel>> getDialogues(String sectionId) async {
    final snapshot = await _firestore
        .collection('sections')
        .doc(sectionId)
        .collection('dialogues')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => DialogueModel.fromFirestore(doc))
        .toList();
  }

  /// Get exercises for a section
  Future<List<ExerciseModel>> getExercises(String sectionId) async {
    final snapshot = await _firestore
        .collection('sections')
        .doc(sectionId)
        .collection('exercises')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => ExerciseModel.fromFirestore(doc))
        .toList();
  }

  /// Search sections by title
  Future<List<SectionModel>> searchSections(String query, String languageCode) async {
    // Note: Firestore doesn't support full-text search
    // This is a basic implementation - consider using Algolia for production
    final allSections = await getAllSections();
    final queryLower = query.toLowerCase();
    
    return allSections.where((section) {
      final title = section.getTitle(languageCode).toLowerCase();
      final titleDe = section.titleDe.toLowerCase();
      return title.contains(queryLower) || titleDe.contains(queryLower);
    }).toList();
  }

  /// Get sections by level
  Future<List<SectionModel>> getSectionsByLevel(String level) async {
    final snapshot = await _firestore
        .collection('sections')
        .where('level', isEqualTo: level)
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => SectionModel.fromFirestore(doc))
        .toList();
  }

  /// Clear cache
  void clearCache() {
    _phasesCache = null;
    _sectionsCache.clear();
  }

  /// Get section count per phase
  Future<Map<String, int>> getSectionCountByPhase() async {
    final sections = await getAllSections();
    final countMap = <String, int>{};
    
    for (final section in sections) {
      countMap[section.phaseId] = (countMap[section.phaseId] ?? 0) + 1;
    }
    
    return countMap;
  }

  /// Get sections with progress for a user
  Future<List<Map<String, dynamic>>> getSectionsWithProgress({
    required String userId,
    required String phaseId,
  }) async {
    final sections = await getSectionsByPhase(phaseId);
    final results = <Map<String, dynamic>>[];

    for (final section in sections) {
      final progressDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(section.id)
          .get();

      results.add({
        'section': section,
        'progress': progressDoc.exists 
            ? ProgressModel.fromFirestore(progressDoc) 
            : null,
      });
    }

    return results;
  }
}
