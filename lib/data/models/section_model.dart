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

  /// Factory to create SectionModel from local JSON file data
  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] ?? '',
      phaseId: json['phaseId'] ?? '',
      order: json['order'] ?? 0,
      titleDe: json['titleDe'] ?? '',
      title: Map<String, String>.from(json['title'] ?? {}),
      description: Map<String, String>.from(json['description'] ?? {}),
      level: json['level'] ?? 'A1',
      estimatedMinutes: json['estimatedMinutes'] ?? 30,
      iconUrl: json['iconUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      isPremium: json['isPremium'] ?? false,
      textContent: json['textContent'] != null
          ? SectionTextContent.fromMap(json['textContent'] as Map<String, dynamic>)
          : null,
      media: json['media'] != null
          ? SectionMedia.fromMap(json['media'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Create a copy of this section with updated fields from JSON data
  SectionModel copyWithJsonData(Map<String, dynamic> jsonData) {
    return SectionModel(
      id: id,
      phaseId: phaseId,
      order: order,
      titleDe: jsonData['titleDe'] ?? titleDe,
      title: jsonData['title'] != null
          ? Map<String, String>.from(jsonData['title'])
          : title,
      description: jsonData['description'] != null
          ? Map<String, String>.from(jsonData['description'])
          : description,
      level: jsonData['level'] ?? level,
      estimatedMinutes: jsonData['estimatedMinutes'] ?? estimatedMinutes,
      iconUrl: jsonData['iconUrl'] ?? iconUrl,
      thumbnailUrl: jsonData['thumbnailUrl'] ?? thumbnailUrl,
      isPremium: jsonData['isPremium'] ?? isPremium,
      textContent: jsonData['textContent'] != null
          ? SectionTextContent.fromMap(jsonData['textContent'] as Map<String, dynamic>)
          : textContent,
      media: jsonData['media'] != null
          ? SectionMedia.fromMap(jsonData['media'] as Map<String, dynamic>)
          : media,
    );
  }
}

class SectionTextContent {
  final Map<String, String> introduction;
  final Map<String, String> grammarFocus;
  final Map<String, String> culturalNotes;
  final Map<String, String> summary;
  final Map<String, List<String>> learningObjectives;

  SectionTextContent({
    required this.introduction,
    required this.grammarFocus,
    required this.culturalNotes,
    required this.summary,
    this.learningObjectives = const {},
  });

  String getIntroduction(String languageCode) {
    return introduction[languageCode] ?? introduction['en'] ?? '';
  }

  /// Grammar focus always returns English content since German grammar tables
  /// should not be translated - students need to learn the original German terms
  String getGrammarFocus(String languageCode) {
    // Always use English for grammar content to preserve German grammar terms
    // This is intentional - grammar tables must show German terms correctly
    return grammarFocus['en'] ?? grammarFocus['de'] ?? '';
  }

  String getCulturalNotes(String languageCode) {
    return culturalNotes[languageCode] ?? culturalNotes['en'] ?? '';
  }

  String getSummary(String languageCode) {
    return summary[languageCode] ?? summary['en'] ?? '';
  }

  List<String> getLearningObjectives(String languageCode) {
    return learningObjectives[languageCode] ?? learningObjectives['en'] ?? [];
  }

  factory SectionTextContent.fromMap(Map<String, dynamic> map) {
    // Helper to parse fields that may be simple strings or nested objects with bullets
    Map<String, String> parseLocalizedField(dynamic field) {
      if (field == null) return {};
      final result = <String, String>{};
      if (field is Map) {
        for (final entry in field.entries) {
          final key = entry.key.toString();
          final value = entry.value;
          if (value is String) {
            result[key] = value;
          } else if (value is Map) {
            // Handle nested bullet structure: {bullet1: "...", bullet2: "..."}
            final bullets = value.entries
                .where((e) => e.key.toString().startsWith('bullet'))
                .map((e) => '• ${e.value}')
                .toList();
            if (bullets.isNotEmpty) {
              result[key] = bullets.join('\n');
            } else {
              // Fallback: join all values
              result[key] = value.values.map((v) => v.toString()).join('\n');
            }
          }
        }
      }
      return result;
    }

    // Parse learningObjectives - can be a simple list (legacy) or multilingual map
    Map<String, List<String>> parseLearningObjectives(dynamic field) {
      if (field == null) return {};
      
      // If it's a simple list of strings (legacy format), use as English
      if (field is List) {
        return {'en': List<String>.from(field)};
      }
      
      // If it's a map with language codes
      if (field is Map) {
        final result = <String, List<String>>{};
        for (final entry in field.entries) {
          final key = entry.key.toString();
          if (entry.value is List) {
            result[key] = List<String>.from(entry.value);
          }
        }
        return result;
      }
      
      return {};
    }

    return SectionTextContent(
      introduction: parseLocalizedField(map['introduction']),
      grammarFocus: parseLocalizedField(map['grammarFocus']),
      culturalNotes: parseLocalizedField(map['culturalNotes']),
      summary: parseLocalizedField(map['summary']),
      learningObjectives: parseLearningObjectives(map['learningObjectives']),
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
