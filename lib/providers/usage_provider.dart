import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/usage/usage_service.dart';
import 'subscription_provider.dart';

final usageServiceProvider =
    Provider<UsageService>((ref) => UsageService());

final usageProvider =
    StateNotifierProvider<UsageNotifier, int>((ref) {
  return UsageNotifier(
    ref.read(usageServiceProvider),
    ref.read(subscriptionProvider),
  );
});

class UsageNotifier extends StateNotifier<int> {
  final UsageService _service;
  final bool _isPremium;

  UsageNotifier(this._service, this._isPremium)
      : super(_service.getCurrentUsage());

  bool get canSendMessage => _service.canSendMessage(_isPremium);

  int get remaining => _service.getRemainingMessages(_isPremium);

  void increment() {
    _service.incrementUsage();
    state = _service.getCurrentUsage();
  }
}
