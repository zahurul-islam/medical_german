/// Dialogue model for clinical conversation scenarios
import 'package:cloud_firestore/cloud_firestore.dart';

class DialogueModel {
  final String id;
  final String sectionId;
  final Map<String, String> title; // {en, bn, hi, ur, tr}
  final Map<String, String> context; // Scene description
  final List<DialogueLine> lines;
  final String audioUrl;
  final String? videoUrl;
  final int order;

  DialogueModel({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.context,
    required this.lines,
    this.audioUrl = '',
    this.videoUrl,
    this.order = 0,
  });

  String getTitle(String languageCode) {
    return title[languageCode] ?? title['en'] ?? '';
  }

  String getContext(String languageCode) {
    return context[languageCode] ?? context['en'] ?? '';
  }

  factory DialogueModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DialogueModel(
      id: doc.id,
      sectionId: data['sectionId'] ?? '',
      title: Map<String, String>.from(data['title'] ?? {}),
      context: Map<String, String>.from(data['context'] ?? {}),
      lines: (data['lines'] as List<dynamic>?)
          ?.map((line) => DialogueLine.fromMap(line))
          .toList() ?? [],
      audioUrl: data['audioUrl'] ?? '',
      videoUrl: data['videoUrl'],
      order: data['order'] ?? 0,
    );
  }

  factory DialogueModel.fromMap(Map<String, dynamic> map, String docId) {
    return DialogueModel(
      id: docId,
      sectionId: map['sectionId'] ?? '',
      title: Map<String, String>.from(map['title'] ?? {}),
      context: Map<String, String>.from(map['context'] ?? {}),
      lines: (map['lines'] as List<dynamic>?)
          ?.map((line) => DialogueLine.fromMap(line))
          .toList() ?? [],
      audioUrl: map['audioUrl'] ?? '',
      videoUrl: map['videoUrl'],
      order: map['order'] ?? 0,
    );
  }

  factory DialogueModel.fromJson(Map<String, dynamic> json) {
    return DialogueModel.fromMap(json, json['id'] ?? '');
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sectionId': sectionId,
      'title': title,
      'context': context,
      'lines': lines.map((line) => line.toMap()).toList(),
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
      'order': order,
    };
  }
}

class DialogueLine {
  final String speaker; // Doctor, Patient, Nurse, etc.
  final String speakerRole; // Role description
  final String germanText;
  final Map<String, String> translation; // {en, bn, hi, ur, tr}
  final String? audioUrl;
  final String? notes;

  DialogueLine({
    required this.speaker,
    this.speakerRole = '',
    required this.germanText,
    required this.translation,
    this.audioUrl,
    this.notes,
  });

  String getTranslation(String languageCode) {
    return translation[languageCode] ?? translation['en'] ?? '';
  }

  factory DialogueLine.fromMap(Map<String, dynamic> map) {
    return DialogueLine(
      speaker: map['speaker'] ?? '',
      speakerRole: map['speakerRole'] ?? '',
      germanText: map['germanText'] ?? '',
      translation: Map<String, String>.from(map['translation'] ?? {}),
      audioUrl: map['audioUrl'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'speaker': speaker,
      'speakerRole': speakerRole,
      'germanText': germanText,
      'translation': translation,
      'audioUrl': audioUrl,
      'notes': notes,
    };
  }
}
