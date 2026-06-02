class AppConstants {
  // App Info
  static const String appName = 'LinguaAI';
  static const String appVersion = '1.0.0';

  // AI Limits
  static const int guestDailyLimit = 5;
  static const int freeDailyLimit = 20;
  static const int premiumDailyLimit = 500;

  // Input Limits
  static const int maxTranslationChars = 500;
  static const int maxChatMessageChars = 1000;

  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyPreferredLang = 'preferred_language';

  // Cloud Function Names
  static const String fnTranslate = 'translate';
  static const String fnChat = 'chat';
  static const String fnVoice = 'voice';
  static const String fnCheckUsage = 'checkUsage';
  static const String fnIncrementUsage = 'incrementUsage';

  // RevenueCat
  static const String rcMonthlyId = 'lingua_premium_monthly';
  static const String rcYearlyId = 'lingua_premium_yearly';
  static const String rcLifetimeId = 'lingua_premium_lifetime';
}
