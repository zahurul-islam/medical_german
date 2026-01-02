/// Exercise model for practice questions
import 'package:cloud_firestore/cloud_firestore.dart';

enum ExerciseType {
  fillBlank,
  multipleChoice,
  matching,
  translation,
  listening,
  ordering,
}

class ExerciseModel {
  final String id;
  final String sectionId;
  final ExerciseType type;
  final Map<String, String> question; // {de, en, bn, hi, ur, tr}
  final List<String>? options; // For multiple choice
  final String correctAnswer;
  final List<String>? correctAnswers; // For matching/ordering
  final Map<String, String> explanation; // {en, bn, hi, ur, tr}
  final String? audioUrl; // For listening exercises
  final String? imageUrl;
  final int order;
  final int points;

  ExerciseModel({
    required this.id,
    required this.sectionId,
    required this.type,
    required this.question,
    this.options,
    required this.correctAnswer,
    this.correctAnswers,
    required this.explanation,
    this.audioUrl,
    this.imageUrl,
    this.order = 0,
    this.points = 10,
  });

  String getQuestion(String languageCode) {
    return question[languageCode] ?? question['en'] ?? '';
  }

  String getExplanation(String languageCode) {
    return explanation[languageCode] ?? explanation['en'] ?? '';
  }

  bool checkAnswer(String answer) {
    if (type == ExerciseType.matching || type == ExerciseType.ordering) {
      return false; // Special handling needed
    }
    return answer.toLowerCase().trim() == correctAnswer.toLowerCase().trim();
  }

  bool checkMultipleAnswers(List<String> answers) {
    if (correctAnswers == null) return false;
    if (answers.length != correctAnswers!.length) return false;
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].toLowerCase().trim() != correctAnswers![i].toLowerCase().trim()) {
        return false;
      }
    }
    return true;
  }

  factory ExerciseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExerciseModel(
      id: doc.id,
      sectionId: data['sectionId'] ?? '',
      type: _parseExerciseType(data['type']),
      question: Map<String, String>.from(data['question'] ?? {}),
      options: data['options'] != null ? List<String>.from(data['options']) : null,
      correctAnswer: data['correctAnswer'] ?? '',
      correctAnswers: data['correctAnswers'] != null 
          ? List<String>.from(data['correctAnswers']) 
          : null,
      explanation: Map<String, String>.from(data['explanation'] ?? {}),
      audioUrl: data['audioUrl'],
      imageUrl: data['imageUrl'],
      order: data['order'] ?? 0,
      points: data['points'] ?? 10,
    );
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map, String docId) {
    return ExerciseModel(
      id: docId,
      sectionId: map['sectionId'] ?? '',
      type: _parseExerciseType(map['type']),
      question: Map<String, String>.from(map['question'] ?? {}),
      options: map['options'] != null ? List<String>.from(map['options']) : null,
      correctAnswer: map['correctAnswer'] ?? '',
      correctAnswers: map['correctAnswers'] != null 
          ? List<String>.from(map['correctAnswers']) 
          : null,
      explanation: Map<String, String>.from(map['explanation'] ?? {}),
      audioUrl: map['audioUrl'],
      imageUrl: map['imageUrl'],
      order: map['order'] ?? 0,
      points: map['points'] ?? 10,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sectionId': sectionId,
      'type': type.name,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'correctAnswers': correctAnswers,
      'explanation': explanation,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'order': order,
      'points': points,
    };
  }

  static ExerciseType _parseExerciseType(String? typeStr) {
    switch (typeStr) {
      case 'fillBlank':
        return ExerciseType.fillBlank;
      case 'multipleChoice':
        return ExerciseType.multipleChoice;
      case 'matching':
        return ExerciseType.matching;
      case 'translation':
        return ExerciseType.translation;
      case 'listening':
        return ExerciseType.listening;
      case 'ordering':
        return ExerciseType.ordering;
      default:
        return ExerciseType.multipleChoice;
    }
  }
}
