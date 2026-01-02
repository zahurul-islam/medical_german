/// Section model for individual learning sections
import 'package:cloud_firestore/cloud_firestore.dart';

class SectionModel {
  final String id;
  final String phaseId;
  final int order;
  final String titleDe; // German title
  final Map<String, String> title; // {en, bn, hi, ur, tr}
  final Map<String, String> description; // {en, bn, hi, ur, tr}
  final String level; // A1, A2, B1, B2, C1
  final int estimatedMinutes;
  final String iconUrl;
  final String thumbnailUrl;
  final bool isPremium;
  final SectionTextContent? textContent;
  final SectionMedia? media;

  SectionModel({
    required this.id,
    required this.phaseId,
    required this.order,
    required this.titleDe,
    required this.title,
    required this.description,
    required this.level,
    this.estimatedMinutes = 30,
    this.iconUrl = '',
    this.thumbnailUrl = '',
    this.isPremium = false,
    this.textContent,
    this.media,
  });

  String getTitle(String languageCode) {
    return title[languageCode] ?? title['en'] ?? '';
  }

  String getDescription(String languageCode) {
    return description[languageCode] ?? description['en'] ?? '';
  }

  factory SectionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SectionModel(
      id: doc.id,
      phaseId: data['phaseId'] ?? '',
      order: data['order'] ?? 0,
      titleDe: data['titleDe'] ?? '',
      title: Map<String, String>.from(data['title'] ?? {}),
      description: Map<String, String>.from(data['description'] ?? {}),
      level: data['level'] ?? 'A1',
      estimatedMinutes: data['estimatedMinutes'] ?? 30,
      iconUrl: data['iconUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      isPremium: data['isPremium'] ?? false,
      textContent: data['textContent'] != null
          ? SectionTextContent.fromMap(data['textContent'])
          : null,
      media: data['media'] != null
          ? SectionMedia.fromMap(data['media'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phaseId': phaseId,
      'order': order,
      'titleDe': titleDe,
      'title': title,
      'description': description,
      'level': level,
      'estimatedMinutes': estimatedMinutes,
      'iconUrl': iconUrl,
      'thumbnailUrl': thumbnailUrl,
      'isPremium': isPremium,
      'textContent': textContent?.toMap(),
      'media': media?.toMap(),
    };
  }
}

class SectionTextContent {
  final Map<String, String> introduction;
  final Map<String, String> grammarFocus;
  final Map<String, String> culturalNotes;
  final Map<String, String> summary;
  final List<String> learningObjectives;

  SectionTextContent({
    required this.introduction,
    required this.grammarFocus,
    required this.culturalNotes,
    required this.summary,
    this.learningObjectives = const [],
  });

  String getIntroduction(String languageCode) {
    return introduction[languageCode] ?? introduction['en'] ?? '';
  }

  String getGrammarFocus(String languageCode) {
    return grammarFocus[languageCode] ?? grammarFocus['en'] ?? '';
  }

  String getCulturalNotes(String languageCode) {
    return culturalNotes[languageCode] ?? culturalNotes['en'] ?? '';
  }

  String getSummary(String languageCode) {
    return summary[languageCode] ?? summary['en'] ?? '';
  }

  factory SectionTextContent.fromMap(Map<String, dynamic> map) {
    return SectionTextContent(
      introduction: Map<String, String>.from(map['introduction'] ?? {}),
      grammarFocus: Map<String, String>.from(map['grammarFocus'] ?? {}),
      culturalNotes: Map<String, String>.from(map['culturalNotes'] ?? {}),
      summary: Map<String, String>.from(map['summary'] ?? {}),
      learningObjectives: List<String>.from(map['learningObjectives'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'introduction': introduction,
      'grammarFocus': grammarFocus,
      'culturalNotes': culturalNotes,
      'summary': summary,
      'learningObjectives': learningObjectives,
    };
  }
}

class SectionMedia {
  final String introVideoUrl;
  final String vocabularyVideoUrl;
  final String dialogueVideoUrl;
  final String? clinicalSkillsVideoUrl;

  SectionMedia({
    this.introVideoUrl = '',
    this.vocabularyVideoUrl = '',
    this.dialogueVideoUrl = '',
    this.clinicalSkillsVideoUrl,
  });

  factory SectionMedia.fromMap(Map<String, dynamic> map) {
    return SectionMedia(
      introVideoUrl: map['introVideoUrl'] ?? '',
      vocabularyVideoUrl: map['vocabularyVideoUrl'] ?? '',
      dialogueVideoUrl: map['dialogueVideoUrl'] ?? '',
      clinicalSkillsVideoUrl: map['clinicalSkillsVideoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'introVideoUrl': introVideoUrl,
      'vocabularyVideoUrl': vocabularyVideoUrl,
      'dialogueVideoUrl': dialogueVideoUrl,
      'clinicalSkillsVideoUrl': clinicalSkillsVideoUrl,
    };
  }
}
