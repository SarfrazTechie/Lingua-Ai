import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription/subscription_service.dart';

final subscriptionServiceProvider =
    Provider<SubscriptionService>((ref) => SubscriptionService());

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, bool>((ref) {
  return SubscriptionNotifier(ref.read(subscriptionServiceProvider));
});

class SubscriptionNotifier extends StateNotifier<bool> {
  final SubscriptionService _service;

  SubscriptionNotifier(this._service) : super(false) {
    _check();
  }

  Future<void> _check() async {
    final premium = await _service.isPremium();
    state = premium;
  }

  Future<void> purchaseMonthly() async {
    await _service.purchaseMonthly();
    await _check();
  }

  Future<void> purchaseYearly() async {
    await _service.purchaseYearly();
    await _check();
  }

  Future<void> restore() async {
    await _service.restorePurchases();
    await _check();
  }

  bool get isPremium => state;
}
