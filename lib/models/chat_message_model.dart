enum MessageRole { user, assistant }

class ChatMessageModel {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.content,
    required this.role,
    required this.createdAt,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) => ChatMessageModel(
        id: map['id'] ?? '',
        content: map['content'] ?? '',
        role: map['role'] == 'user' ? MessageRole.user : MessageRole.assistant,
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'content': content,
        'role': role.name,
        'createdAt': createdAt.toIso8601String(),
      };

  bool get isUser => role == MessageRole.user;
}
