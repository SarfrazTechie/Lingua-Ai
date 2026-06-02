class FirestorePaths {
  // Users
  static String userDoc(String uid) => 'users/$uid';
  static String userProfile(String uid) => 'users/$uid/profile';

  // Usage
  static String usageDoc(String uid, String date) =>
      'usage/$uid/daily/$date';

  // Translations
  static String translationHistory(String uid) =>
      'translations/$uid/history';
  static String translationDoc(String uid, String id) =>
      'translations/$uid/history/$id';

  // Chats
  static String chatSessions(String uid) => 'chats/$uid/sessions';
  static String chatMessages(String uid, String sessionId) =>
      'chats/$uid/sessions/$sessionId/messages';
}
