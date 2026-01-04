/// Vocabulary model for German medical terms
import 'package:cloud_firestore/cloud_firestore.dart';

class VocabularyModel {
  final String id;
  final String sectionId;
  final String germanTerm;
  final String pronunciation; // IPA pronunciation
  final String article; // der, die, das
  final String plural;
  final Map<String, String> translation; // {en, bn, hi, ur, tr}
  final String exampleSentence;
  final Map<String, String> exampleTranslation;
  final String audioUrl;
  final String? imageUrl;
  final String category; // noun, verb, adjective, phrase
  final int order;

  VocabularyModel({
    required this.id,
    required this.sectionId,
    required this.germanTerm,
    this.pronunciation = '',
    this.article = '',
    this.plural = '',
    required this.translation,
    this.exampleSentence = '',
    this.exampleTranslation = const {},
    this.audioUrl = '',
    this.imageUrl,
    this.category = 'noun',
    this.order = 0,
  });

  String getTranslation(String languageCode) {
    return translation[languageCode] ?? translation['en'] ?? '';
  }

  String getExampleTranslation(String languageCode) {
    return exampleTranslation[languageCode] ?? exampleTranslation['en'] ?? '';
  }

  String get fullGermanTerm {
    if (article.isNotEmpty) {
      return '$article $germanTerm';
    }
    return germanTerm;
  }

  factory VocabularyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VocabularyModel(
      id: doc.id,
      sectionId: data['sectionId'] ?? '',
      germanTerm: data['germanTerm'] ?? '',
      pronunciation: data['pronunciation'] ?? '',
      article: data['article'] ?? '',
      plural: data['plural'] ?? '',
      translation: Map<String, String>.from(data['translation'] ?? {}),
      exampleSentence: data['exampleSentence'] ?? '',
      exampleTranslation: Map<String, String>.from(data['exampleTranslation'] ?? {}),
      audioUrl: data['audioUrl'] ?? '',
      imageUrl: data['imageUrl'],
      category: data['category'] ?? 'noun',
      order: data['order'] ?? 0,
    );
  }

  factory VocabularyModel.fromMap(Map<String, dynamic> map, String docId) {
    return VocabularyModel(
      id: docId,
      sectionId: map['sectionId'] ?? '',
      germanTerm: map['germanTerm'] ?? '',
      pronunciation: map['pronunciation'] ?? '',
      article: map['article'] ?? '',
      plural: map['plural'] ?? '',
      translation: Map<String, String>.from(map['translation'] ?? {}),
      exampleSentence: map['exampleSentence'] ?? '',
      exampleTranslation: Map<String, String>.from(map['exampleTranslation'] ?? {}),
      audioUrl: map['audioUrl'] ?? '',
      imageUrl: map['imageUrl'],
      category: map['category'] ?? 'noun',
      order: map['order'] ?? 0,
    );
  }

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel.fromMap(json, json['id'] ?? '');
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sectionId': sectionId,
      'germanTerm': germanTerm,
      'pronunciation': pronunciation,
      'article': article,
      'plural': plural,
      'translation': translation,
      'exampleSentence': exampleSentence,
      'exampleTranslation': exampleTranslation,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'category': category,
      'order': order,
    };
  }
}
