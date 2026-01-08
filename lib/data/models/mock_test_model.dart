/// Mock Test model for FSP and KP exams
import 'package:cloud_firestore/cloud_firestore.dart';

enum MockTestType {
  fsp, // Fachsprachprüfung - Medical German Language Exam
  kp,  // Kenntnisprüfung - Medical Knowledge Exam
}

class MockTestModel {
  final String id;
  final String phaseId;
  final MockTestType type;
  final Map<String, String> title;
  final Map<String, String> description;
  final String level;
  final int questionCount;
  final int durationMinutes;
  final int passingScore; // Percentage required to pass
  final List<MockTestQuestion> questions;

  MockTestModel({
    required this.id,
    required this.phaseId,
    required this.type,
    required this.title,
    required this.description,
    required this.level,
    required this.questionCount,
    required this.durationMinutes,
    required this.passingScore,
    required this.questions,
  });

  String getTitle(String languageCode) {
    return title[languageCode] ?? title['en'] ?? '';
  }

  String getDescription(String languageCode) {
    return description[languageCode] ?? description['en'] ?? '';
  }

  String get typeDisplayName {
    switch (type) {
      case MockTestType.fsp:
        return 'Fachsprachprüfung (FSP)';
      case MockTestType.kp:
        return 'Kenntnisprüfung (KP)';
    }
  }

  String get typeShortName {
    switch (type) {
      case MockTestType.fsp:
        return 'FSP';
      case MockTestType.kp:
        return 'KP';
    }
  }

  factory MockTestModel.fromJson(Map<String, dynamic> json) {
    final questionsList = (json['questions'] as List?)
        ?.map((q) => MockTestQuestion.fromJson(q as Map<String, dynamic>))
        .toList() ?? [];
    
    return MockTestModel(
      id: json['id'] ?? '',
      phaseId: json['phaseId'] ?? '',
      type: _parseTestType(json['type']),
      title: Map<String, String>.from(json['title'] ?? {}),
      description: Map<String, String>.from(json['description'] ?? {}),
      level: json['level'] ?? '',
      questionCount: json['questionCount'] ?? questionsList.length,
      durationMinutes: json['durationMinutes'] ?? 60,
      passingScore: json['passingScore'] ?? 60,
      questions: questionsList,
    );
  }

  factory MockTestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MockTestModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phaseId': phaseId,
      'type': type.name,
      'title': title,
      'description': description,
      'level': level,
      'questionCount': questionCount,
      'durationMinutes': durationMinutes,
      'passingScore': passingScore,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  static MockTestType _parseTestType(String? typeStr) {
    switch (typeStr) {
      case 'fsp':
        return MockTestType.fsp;
      case 'kp':
        return MockTestType.kp;
      default:
        return MockTestType.fsp;
    }
  }
}

class MockTestQuestion {
  final String id;
  final String type; // multipleChoice, scenario, oral, written
  final Map<String, String> question;
  final Map<String, String>? scenario; // For scenario-based questions
  final List<String>? options;
  final String correctAnswer;
  final Map<String, String> explanation;
  final int points;
  final String? imageUrl;
  final String? audioUrl;

  MockTestQuestion({
    required this.id,
    required this.type,
    required this.question,
    this.scenario,
    this.options,
    required this.correctAnswer,
    required this.explanation,
    this.points = 1,
    this.imageUrl,
    this.audioUrl,
  });

  String getQuestion(String languageCode) {
    return question[languageCode] ?? question['de'] ?? question['en'] ?? '';
  }

  String getScenario(String languageCode) {
    return scenario?[languageCode] ?? scenario?['de'] ?? scenario?['en'] ?? '';
  }

  String getExplanation(String languageCode) {
    return explanation[languageCode] ?? explanation['en'] ?? '';
  }

  factory MockTestQuestion.fromJson(Map<String, dynamic> json) {
    // Safely parse maps
    Map<String, String> questionMap = {};
    if (json['question'] is Map) {
      questionMap = Map<String, String>.from(
        (json['question'] as Map).map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
      );
    }

    Map<String, String>? scenarioMap;
    if (json['scenario'] is Map) {
      scenarioMap = Map<String, String>.from(
        (json['scenario'] as Map).map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
      );
    }

    Map<String, String> explanationMap = {};
    if (json['explanation'] is Map) {
      explanationMap = Map<String, String>.from(
        (json['explanation'] as Map).map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
      );
    }

    List<String>? optionsList;
    if (json['options'] is List) {
      optionsList = (json['options'] as List).map((e) => e?.toString() ?? '').toList();
    }

    return MockTestQuestion(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'multipleChoice',
      question: questionMap,
      scenario: scenarioMap,
      options: optionsList,
      correctAnswer: json['correctAnswer']?.toString() ?? '',
      explanation: explanationMap,
      points: (json['points'] is int) ? json['points'] : 1,
      imageUrl: json['imageUrl']?.toString(),
      audioUrl: json['audioUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'question': question,
      if (scenario != null) 'scenario': scenario,
      if (options != null) 'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'points': points,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (audioUrl != null) 'audioUrl': audioUrl,
    };
  }
}

