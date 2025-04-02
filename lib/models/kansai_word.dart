// lib/models/kansai_word.dart
import 'package:flutter/foundation.dart'; // For @required in older Flutter versions, or just use required keyword

class KansaiWord {
  final int id;
  final String kansaiExpression;
  final String standardJapanese;
  final String englishTranslation;
  final String exampleSentence;
  final String standardJapaneseSentence;
  final String englishSentence;
  final String location;

  KansaiWord({
    required this.id,
    required this.kansaiExpression,
    required this.standardJapanese,
    required this.englishTranslation,
    required this.exampleSentence,
    required this.standardJapaneseSentence,
    required this.englishSentence,
    required this.location,
  });

  // Factory constructor to create a KansaiWord from a JSON map
  factory KansaiWord.fromJson(Map<String, dynamic> json) {
    return KansaiWord(
      id: json['id'] ?? 0, // Provide default or handle null
      kansaiExpression: json['kansaiExpression'] ?? '',
      standardJapanese: json['standardJapanese'] ?? '',
      englishTranslation: json['englishTranslation'] ?? '',
      exampleSentence: json['exampleSentence'] ?? '',
      standardJapaneseSentence: json['standardJapaneseSentence'] ?? '',
      englishSentence: json['englishSentence'] ?? '',
      location: json['location'] ?? '',
    );
  }
}