enum SubscriptionPlan { guest, free, premium }

class SubscriptionModel {
  final String userId;
  final SubscriptionPlan plan;
  final DateTime? expiresAt;
  final bool isActive;

  const SubscriptionModel({
    required this.userId,
    this.plan = SubscriptionPlan.free,
    this.expiresAt,
    this.isActive = false,
  });

  bool get isPremium => plan == SubscriptionPlan.premium && isActive;
  bool get isGuest => plan == SubscriptionPlan.guest;

  int get dailyLimit {
    switch (plan) {
      case SubscriptionPlan.guest:
        return 5;
      case SubscriptionPlan.free:
        return 20;
      case SubscriptionPlan.premium:
        return 500;
    }
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) =>
      SubscriptionModel(
        userId: map['userId'] ?? '',
        plan: SubscriptionPlan.values.firstWhere(
          (p) => p.name == map['plan'],
          orElse: () => SubscriptionPlan.free,
        ),
        expiresAt: map['expiresAt'] != null
            ? DateTime.tryParse(map['expiresAt'])
            : null,
        isActive: map['isActive'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'plan': plan.name,
        'expiresAt': expiresAt?.toIso8601String(),
        'isActive': isActive,
      };
}
