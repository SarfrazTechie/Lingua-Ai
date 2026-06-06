import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/translation_model.dart';
import '../services/ai/translation_service.dart';
import '../services/firebase/functions_service.dart';
import '../services/firebase/firestore_service.dart';
import 'auth_provider.dart';
import 'history_provider.dart';

final functionsServiceProvider =
    Provider<FunctionsService>((ref) => FunctionsService());


final translationServiceProvider = Provider<TranslationService>(
    (ref) => TranslationService(ref.read(functionsServiceProvider)));

final translationProvider =
    StateNotifierProvider<TranslationNotifier, AsyncValue<TranslationModel?>>((ref) {
  return TranslationNotifier(ref.read(translationServiceProvider), ref);
});

class TranslationNotifier
    extends StateNotifier<AsyncValue<TranslationModel?>> {
  final TranslationService _service;
  final Ref _ref;

  TranslationNotifier(this._service, this._ref) : super(const AsyncValue.data(null));

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

      final translation = TranslationModel(
        sourceText: text,
        translatedText: result,
        sourceLang: sourceLang,
        targetLang: targetLang,
        createdAt: DateTime.now(),
      );
      

      state = AsyncValue.data(translation);

      // DB mein save karo
      final user = _ref.read(authProvider).valueOrNull;
      if (user != null) {
        await _ref.read(firestoreServiceProvider).saveTranslation(user.uid, translation);
        _ref.invalidate(historyProvider);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }


  void clear() => state = const AsyncValue.data(null);
}
