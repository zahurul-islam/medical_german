/// Phase model for learning phases (A1-A2, B1-B2, C1)
import 'package:cloud_firestore/cloud_firestore.dart';

class PhaseModel {
  final String id;
  final int order;
  final Map<String, String> title; // {en, bn, hi, ur, tr, de}
  final Map<String, String> description; // {en, bn, hi, ur, tr}
  final String level; // A1-A2, B1-B2, C1
  final String iconUrl;
  final int sectionCount;
  final String colorHex;
  final String gradientStartHex;
  final String gradientEndHex;

  PhaseModel({
    required this.id,
    required this.order,
    required this.title,
    required this.description,
    required this.level,
    this.iconUrl = '',
    required this.sectionCount,
    this.colorHex = '#1A5F7A',
    this.gradientStartHex = '#1A5F7A',
    this.gradientEndHex = '#2D8BB4',
  });

  String getTitle(String languageCode) {
    return title[languageCode] ?? title['en'] ?? '';
  }

  String getDescription(String languageCode) {
    return description[languageCode] ?? description['en'] ?? '';
  }

  factory PhaseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PhaseModel(
      id: doc.id,
      order: data['order'] ?? 0,
      title: Map<String, String>.from(data['title'] ?? {}),
      description: Map<String, String>.from(data['description'] ?? {}),
      level: data['level'] ?? '',
      iconUrl: data['iconUrl'] ?? '',
      sectionCount: data['sectionCount'] ?? 0,
      colorHex: data['colorHex'] ?? '#1A5F7A',
      gradientStartHex: data['gradientStartHex'] ?? '#1A5F7A',
      gradientEndHex: data['gradientEndHex'] ?? '#2D8BB4',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'order': order,
      'title': title,
      'description': description,
      'level': level,
      'iconUrl': iconUrl,
      'sectionCount': sectionCount,
      'colorHex': colorHex,
      'gradientStartHex': gradientStartHex,
      'gradientEndHex': gradientEndHex,
    };
  }
}
