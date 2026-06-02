import '../firebase/functions_service.dart';
import '../../models/chat_message_model.dart';

class ChatService {
  final FunctionsService _functions;

  ChatService(this._functions);

  Future<String> sendMessage({
    required String message,
    required List<ChatMessageModel> history,
    String? mode,
  }) async {
    final historyMaps = history
        .map((m) => {'role': m.role.name, 'content': m.content})
        .toList();

    return await _functions.chat(
      message: message,
      history: historyMaps,
      mode: mode,
    );
  }
}
