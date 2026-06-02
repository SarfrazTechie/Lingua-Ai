import '../../core/constants/app_constants.dart';

class UsageService {
  final Map<String, int> _localUsage = {};

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  int getCurrentUsage() => _localUsage[_todayKey] ?? 0;

  bool canSendMessage(bool isPremium) {
    final limit = isPremium
        ? AppConstants.premiumDailyLimit
        : AppConstants.freeDailyLimit;
    return getCurrentUsage() < limit;
  }

  void incrementUsage() {
    _localUsage[_todayKey] = getCurrentUsage() + 1;
  }

  int getRemainingMessages(bool isPremium) {
    final limit = isPremium
        ? AppConstants.premiumDailyLimit
        : AppConstants.freeDailyLimit;
    return (limit - getCurrentUsage()).clamp(0, limit);
  }
}
