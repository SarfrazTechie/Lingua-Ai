import 'package:cloud_functions/cloud_functions.dart';
import '../../core/errors/app_exception.dart';

class FunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<String> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
    String? tone,
  }) async {
    try {
      final callable = _functions.httpsCallable('translateText');
      final result = await callable.call({
        'text': text,
        'sourceLang': sourceLang,
        'targetLang': targetLang,
        'tone': tone ?? 'neutral',
      });
      return result.data['translation'] as String? ?? '';
    } on FirebaseFunctionsException catch (e) {
      throw NetworkException(e.message ?? 'Translation failed');
    } catch (e) {
      throw NetworkException('Translation failed: $e');
    }
  }

  Future<String> chat({
    required String message,
    required List<Map<String, String>> history,
    String? mode,
  }) async {
    try {
      final callable = _functions.httpsCallable('chatMessage');
      final result = await callable.call({
        'message': message,
        'history': history,
        'mode': mode ?? 'Travel Companion',
      });
      return result.data['reply'] as String? ?? '';
    } on FirebaseFunctionsException catch (e) {
      throw NetworkException(e.message ?? 'Chat failed');
    } catch (e) {
      throw NetworkException('Chat failed: $e');
    }
  }
}
