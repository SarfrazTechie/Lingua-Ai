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
        userId: map['userId'] ?? '',
        date: map['date'] ?? '',
        messageCount: map['messageCount'] ?? 0,
        tokenCount: map['tokenCount'] ?? 0,
        lastUpdated:
            DateTime.tryParse(map['lastUpdated'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'date': date,
        'messageCount': messageCount,
        'tokenCount': tokenCount,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  UsageModel copyWith({int? messageCount, int? tokenCount}) => UsageModel(
        userId: userId,
        date: date,
        messageCount: messageCount ?? this.messageCount,
        tokenCount: tokenCount ?? this.tokenCount,
        lastUpdated: DateTime.now(),
      );
}
