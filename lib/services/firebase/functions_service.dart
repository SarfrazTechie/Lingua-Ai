import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/errors/app_exception.dart';

class FunctionsService {
  final _supabase = Supabase.instance.client;

  Future<String> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
    String? tone,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'translate-text',
        body: {
          'text': text,
          'sourceLang': sourceLang,
          'targetLang': targetLang,
          'tone': tone ?? 'neutral',
        },
      );
      if (response.status != 200) {
        throw NetworkException('Translation failed: ${response.data}');
      }
      return response.data['translation'] as String? ?? '';
    } on FunctionException catch (e) {
      throw NetworkException(e.details?.toString() ?? 'Translation failed');
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
      final response = await _supabase.functions.invoke(
        'chat-message',
        body: {
          'message': message,
          'history': history,
          'mode': mode ?? 'Travel Companion',
        },
      );
      if (response.status != 200) {
        throw NetworkException('Chat failed: ${response.data}');
      }
      return response.data['reply'] as String? ?? '';
    } on FunctionException catch (e) {
      throw NetworkException(e.details?.toString() ?? 'Chat failed');
    } catch (e) {
      throw NetworkException('Chat failed: $e');
    }
  }
}
