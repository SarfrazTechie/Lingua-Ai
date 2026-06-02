import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/translation_model.dart';
import '../../models/user_model.dart';
import '../../models/chat_message_model.dart';
import '../../models/usage_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // USER
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toMap());
  }

  // TRANSLATIONS
  Future<List<TranslationModel>> getTranslationHistory(String uid) async {
    final snap = await _db
        .collection('translations')
        .doc(uid)
        .collection('history')
        .orderBy('createdAt', descending: true)
        .limit(100)
        .get();
    return snap.docs.map((d) => TranslationModel.fromFirestore(d)).toList();
  }

  Future<void> saveTranslation(String uid, TranslationModel translation) async {
    await _db
        .collection('translations')
        .doc(uid)
        .collection('history')
        .add(translation.toFirestore());
  }

  Future<void> deleteTranslation(String uid, String translationId) async {
    await _db
        .collection('translations')
        .doc(uid)
        .collection('history')
        .doc(translationId)
        .delete();
  }

  Future<void> updateTranslation(String uid, TranslationModel translation) async {
    if (translation.id == null) return;
    await _db
        .collection('translations')
        .doc(uid)
        .collection('history')
        .doc(translation.id)
        .update(translation.toFirestore());
  }

  Future<void> clearHistory(String uid) async {
    final snap = await _db
        .collection('translations')
        .doc(uid)
        .collection('history')
        .get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // CHAT
  Future<void> saveChatMessage(String uid, String sessionId, ChatMessageModel message) async {
    await _db
        .collection('chats')
        .doc(uid)
        .collection('sessions')
        .doc(sessionId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<List<ChatMessageModel>> getChatMessages(String uid, String sessionId) async {
    final snap = await _db
        .collection('chats')
        .doc(uid)
        .collection('sessions')
        .doc(sessionId)
        .collection('messages')
        .orderBy('createdAt')
        .get();
    return snap.docs.map((d) => ChatMessageModel.fromMap(d.data())).toList();
  }

  // USAGE
  Future<UsageModel?> getUsage(String uid, String date) async {
    final doc = await _db
        .collection('usage')
        .doc(uid)
        .collection('daily')
        .doc(date)
        .get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return UsageModel.fromMap(data);
  }

  Future<void> incrementUsage(String uid, String date, int tokens) async {
    final ref = _db
        .collection('usage')
        .doc(uid)
        .collection('daily')
        .doc(date);
    await ref.set({
      'messageCount': FieldValue.increment(1),
      'tokenCount': FieldValue.increment(tokens),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // PREMIUM
  Future<void> setPremiumStatus(String uid, bool isPremium) async {
    await _db.collection('users').doc(uid).update({'isPremium': isPremium});
  }

  Future<bool> getPremiumStatus(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    final data = doc.data() as Map<String, dynamic>?;
      return (data?['isPremium'] as bool?) ?? false;
  }
}
