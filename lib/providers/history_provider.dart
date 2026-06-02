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
    final userState = ref.watch(authProvider);
    final user = userState.value;
    if (user == null) return [];
    final firestoreService = ref.read(firestoreServiceProvider);
    return firestoreService.getTranslationHistory(user.uid);
  }

  Future<void> deleteItem(String id) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.deleteTranslation(user.uid, id);
    state = AsyncData(
      state.value?.where((item) => item.id != id).toList() ?? [],
    );
  }

  Future<void> toggleSave(TranslationModel item) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;
    final firestoreService = ref.read(firestoreServiceProvider);
    final updated = item.copyWith(isSaved: !(item.isSaved ?? false));
    await firestoreService.updateTranslation(user.uid, updated);
    state = AsyncData(
      state.value?.map((t) => t.id == item.id ? updated : t).toList() ?? [],
    );
  }

  Future<void> clearAll() async {
    final user = ref.read(authProvider).value;
    if (user == null) return;
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.clearHistory(user.uid);
    state = const AsyncData([]);
  }
}
