import '../firebase/functions_service.dart';

class TranslationService {
  final FunctionsService _functions;

  TranslationService(this._functions);

  Future<String> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
    String tone = 'neutral',
  }) async {
    if (text.trim().isEmpty) return '';
    return await _functions.translate(
      text: text,
      sourceLang: sourceLang,
      targetLang: targetLang,
      tone: tone,
    );
  }
}
