import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/translation_model.dart';
import '../../models/user_model.dart';
import '../../models/chat_message_model.dart';
import '../../models/usage_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  final _db = Supabase.instance.client;

  // USER
  Future<void> createUser(UserModel user) async {
    await _db.from('users').insert(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final data = await _db
          .from('users')
          .select()
          .eq('uid', uid)
          .single();
      return UserModel.fromMap(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    await _db
        .from('users')
        .update(user.toMap())
        .eq('uid', user.uid);
  }

  // TRANSLATIONS
  Future<List<TranslationModel>> getTranslationHistory(String uid) async {
    try {
      final data = await _db
          .from('translations')
          .select()
          .eq('uid', uid)
          .order('created_at', ascending: false)
          .limit(100);
      return data.map((d) => TranslationModel.fromMap(d)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTranslation(String uid, TranslationModel translation) async {
    await _db.from('translations').insert({
      ...translation.toMap(),
      'uid': uid,
    });
  }

  Future<void> deleteTranslation(String uid, String translationId) async {
    await _db
        .from('translations')
        .delete()
        .eq('id', translationId)
        .eq('uid', uid);
  }

  Future<void> updateTranslation(String uid, TranslationModel translation) async {
    if (translation.id == null) return;
    await _db
        .from('translations')
        .update(translation.toMap())
        .eq('id', translation.id!)
        .eq('uid', uid);
  }

  Future<void> clearHistory(String uid) async {
    await _db
        .from('translations')
        .delete()
        .eq('uid', uid);
  }

  // CHAT
  Future<void> saveChatMessage(String uid, String sessionId, ChatMessageModel message) async {
    await _db.from('chat_messages').insert({
      ...message.toMap(),
      'uid': uid,
      'session_id': sessionId,
    });
  }

  Future<List<ChatMessageModel>> getChatMessages(String uid, String sessionId) async {
    final data = await _db
        .from('chat_messages')
        .select()
        .eq('uid', uid)
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);
    return data.map((d) => ChatMessageModel.fromMap(d)).toList();
  }

  // USAGE
  Future<UsageModel?> getUsage(String uid, String date) async {
    try {
      final data = await _db
          .from('usage')
          .select()
          .eq('uid', uid)
          .eq('date', date)
          .single();
      return UsageModel.fromMap(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> incrementUsage(String uid, String date, int tokens) async {
    final existing = await getUsage(uid, date);
    if (existing == null) {
      await _db.from('usage').insert({
        'uid': uid,
        'date': date,
        'message_count': 1,
        'token_count': tokens,
        'last_updated': DateTime.now().toIso8601String(),
      });
    } else {
      await _db.from('usage').update({
        'message_count': existing.messageCount + 1,
        'token_count': existing.tokenCount + tokens,
        'last_updated': DateTime.now().toIso8601String(),
      })
      .eq('uid', uid)
      .eq('date', date);
    }
  }

  // PREMIUM
  Future<void> setPremiumStatus(String uid, bool isPremium) async {
    await _db
        .from('users')
        .update({'is_premium': isPremium})
        .eq('uid', uid);
  }

  Future<bool> getPremiumStatus(String uid) async {
    try {
      final data = await _db
          .from('users')
          .select('is_premium')
          .eq('uid', uid)
          .single();
      return (data['is_premium'] as bool?) ?? false;
    } catch (_) {
      return false;
    }
  }
}
