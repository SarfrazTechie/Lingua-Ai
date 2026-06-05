import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message_model.dart';
import '../services/ai/chat_service.dart';
import '../providers/translation_provider.dart';

final chatServiceProvider = Provider<ChatService>(
    (ref) => ChatService(ref.read(functionsServiceProvider)));

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessageModel>>((ref) {
  return ChatNotifier(ref.read(chatServiceProvider));
});

class ChatNotifier extends StateNotifier<List<ChatMessageModel>> {
  final ChatService _service;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ChatNotifier(this._service) : super([]);

  Future<void> sendMessage(String content, {String? mode}) async {
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
