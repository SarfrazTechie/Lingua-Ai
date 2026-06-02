import 'package:cloud_firestore/cloud_firestore.dart';

class TranslationModel {
  final String? id;
  final String? sourceText;
  final String? translatedText;
  final String? sourceLang;
  final String? targetLang;
  final DateTime? createdAt;
  final bool? isSaved;

  const TranslationModel({
    this.id,
    this.sourceText,
    this.translatedText,
    this.sourceLang,
    this.targetLang,
    this.createdAt,
    this.isSaved,
  });

  factory TranslationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TranslationModel(
      id: doc.id,
      sourceText: data['sourceText'] as String?,
      translatedText: data['translatedText'] as String?,
      sourceLang: data['sourceLang'] as String?,
      targetLang: data['targetLang'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      isSaved: data['isSaved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sourceText': sourceText,
      'translatedText': translatedText,
      'sourceLang': sourceLang,
      'targetLang': targetLang,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'isSaved': isSaved ?? false,
    };
  }

  TranslationModel copyWith({
    String? id,
    String? sourceText,
    String? translatedText,
    String? sourceLang,
    String? targetLang,
    DateTime? createdAt,
    bool? isSaved,
  }) {
    return TranslationModel(
      id: id ?? this.id,
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
