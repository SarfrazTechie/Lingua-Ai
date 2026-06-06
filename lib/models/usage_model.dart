class UsageModel {
  final String userId;
  final String date;
  final int messageCount;
  final int tokenCount;
  final DateTime lastUpdated;

  const UsageModel({
    required this.userId,
    required this.date,
    this.messageCount = 0,
    this.tokenCount = 0,
    required this.lastUpdated,
  });

  factory UsageModel.fromMap(Map<String, dynamic> map) => UsageModel(
        userId: map['uid'] ?? '',
        date: map['date'] ?? '',
        messageCount: map['message_count'] ?? 0,
        tokenCount: map['token_count'] ?? 0,
        lastUpdated:
            DateTime.tryParse(map['last_updated'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'uid': userId,
        'date': date,
        'message_count': messageCount,
        'token_count': tokenCount,
        'last_updated': lastUpdated.toIso8601String(),
      };

  UsageModel copyWith({int? messageCount, int? tokenCount}) => UsageModel(
        userId: userId,
        date: date,
        messageCount: messageCount ?? this.messageCount,
        tokenCount: tokenCount ?? this.tokenCount,
        lastUpdated: DateTime.now(),
      );
}

