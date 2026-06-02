import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/translation_model.dart';
import '../services/ai/translation_service.dart';
import '../services/firebase/functions_service.dart';
import '../services/firebase/firestore_service.dart';

final functionsServiceProvider =
    Provider<FunctionsService>((ref) => FunctionsService());

final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

final translationServiceProvider = Provider<TranslationService>(
    (ref) => TranslationService(ref.read(functionsServiceProvider)));

final translationProvider =
    StateNotifierProvider<TranslationNotifier, AsyncValue<TranslationModel?>>((ref) {
  return TranslationNotifier(ref.read(translationServiceProvider));
});

class TranslationNotifier
    extends StateNotifier<AsyncValue<TranslationModel?>> {
  final TranslationService _service;

  TranslationNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
    String tone = 'neutral',
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _service.translate(
        text: text,
        sourceLang: sourceLang,
        targetLang: targetLang,
        tone: tone,
      );
      state = AsyncValue.data(TranslationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sourceText: text,
        translatedText: result,
        sourceLang: sourceLang,
        targetLang: targetLang,
        createdAt: DateTime.now(),
      ));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void clear() => state = const AsyncValue.data(null);
}
