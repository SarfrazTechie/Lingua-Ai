import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_message_model.dart';
import '../services/ai/chat_service.dart';
import '../providers/translation_provider.dart';

const int kFreeDailyLimit = 5;

final chatServiceProvider = Provider<ChatService>(
    (ref) => ChatService(ref.read(functionsServiceProvider)));

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessageModel>>((ref) {
  return ChatNotifier(ref.read(chatServiceProvider));
});

class ChatNotifier extends StateNotifier<List<ChatMessageModel>> {
  final ChatService _service;
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  bool _limitReached = false;
  bool get isLoading => _isLoading;
  bool get limitReached => _limitReached;

  ChatNotifier(this._service) : super([]);

  Future<int> getTodayUsage() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return 0;
    final res = await _supabase
        .from('chat_usage')
        .select('message_count')
        .eq('user_id', userId)
        .eq('usage_date', DateTime.now().toIso8601String().substring(0, 10))
        .maybeSingle();
    return res?['message_count'] as int? ?? 0;
  }

  Future<void> _incrementUsage() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await _supabase.from('chat_usage').upsert({
      'user_id': userId,
      'usage_date': today,
      'message_count': (await getTodayUsage()) + 1,
    }, onConflict: 'user_id,usage_date');
  }

  Future<void> sendMessage(String content, {String? mode}) async {
    final usage = await getTodayUsage();
    if (usage >= kFreeDailyLimit) {
      _limitReached = true;
      state = [...state];
      return;
    }

    final userMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );
    state = [...state, userMsg];
    _isLoading = true;

    try {
      final response = await _service.sendMessage(
        message: content,
        history: state,
        mode: mode,
      );
      await _incrementUsage();
      final aiMsg = ChatMessageModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        content: response,
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
      );
      state = [...state, aiMsg];
    } catch (e) {
      state = [
        ...state,
        ChatMessageModel(
          id: '${DateTime.now().millisecondsSinceEpoch}_err',
          content: 'Sorry, something went wrong. Please try again.',
          role: MessageRole.assistant,
          createdAt: DateTime.now(),
        )
      ];
    } finally {
      _isLoading = false;
    }
  }

  void clearChat() => state = [];
}