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

  factory TranslationModel.fromMap(Map<String, dynamic> data) {
    return TranslationModel(
      id: data['id'] as String?,
      sourceText: data['source_text'] as String?,
      translatedText: data['translated_text'] as String?,
      sourceLang: data['source_lang'] as String?,
      targetLang: data['target_lang'] as String?,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : null,
      isSaved: data['is_saved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source_text': sourceText,
      'translated_text': translatedText,
      'source_lang': sourceLang,
      'target_lang': targetLang,
      'created_at': createdAt?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      'is_saved': isSaved ?? false,
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
