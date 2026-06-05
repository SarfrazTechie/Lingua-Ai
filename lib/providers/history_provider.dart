import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/translation_model.dart';
import '../services/firebase/firestore_service.dart';
import 'auth_provider.dart';

final historyProvider = AsyncNotifierProvider<HistoryNotifier, List<TranslationModel>>(
  HistoryNotifier.new,
);

class HistoryNotifier extends AsyncNotifier<List<TranslationModel>> {
  @override
  Future<List<TranslationModel>> build() async {
    final authState = ref.watch(authProvider);
    final user = authState.valueOrNull;

    // Guest user ya loading — empty list, koi error nahi
    if (user == null) return [];

    try {
      final service = ref.read(firestoreServiceProvider);
      return await service.getTranslationHistory(user.uid);
    } catch (_) {
      return [];
    }
  }

  Future<void> deleteItem(String id) async {
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) return;
    try {
      await ref.read(firestoreServiceProvider).deleteTranslation(user.uid, id);
      state = AsyncData(
        state.value?.where((item) => item.id != id).toList() ?? [],
      );
    } catch (_) {}
  }

  Future<void> toggleSave(TranslationModel item) async {
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) return;
    try {
      final updated = item.copyWith(isSaved: !(item.isSaved ?? false));
      await ref.read(firestoreServiceProvider).updateTranslation(user.uid, updated);
      state = AsyncData(
        state.value?.map((t) => t.id == item.id ? updated : t).toList() ?? [],
      );
    } catch (_) {}
  }

  Future<void> clearAll() async {
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) return;
    try {
      await ref.read(firestoreServiceProvider).clearHistory(user.uid);
      state = const AsyncData([]);
    } catch (_) {}
  }
}