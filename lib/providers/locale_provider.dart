import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ye provider app ki language store karta hai
// Jab user settings mein language change kare to poori app ki language shift ho jati hai

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadSaved();
  }

  static const _key = 'app_locale';

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'en';
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (_) => LocaleNotifier(),
);

// Ye list settings screen ke language picker mein use hogi
const appLanguages = [
  {'code': 'en', 'name': 'English',    'native': 'English',   'flag': '🇬🇧'},
  {'code': 'ur', 'name': 'Urdu',       'native': 'اردو',      'flag': '🇵🇰'},
  {'code': 'ar', 'name': 'Arabic',     'native': 'العربية',   'flag': '🇸🇦'},
  {'code': 'fr', 'name': 'French',     'native': 'Français',  'flag': '🇫🇷'},
  {'code': 'es', 'name': 'Spanish',    'native': 'Español',   'flag': '🇪🇸'},
  {'code': 'de', 'name': 'German',     'native': 'Deutsch',   'flag': '🇩🇪'},
  {'code': 'zh', 'name': 'Chinese',    'native': '中文',      'flag': '🇨🇳'},
  {'code': 'ja', 'name': 'Japanese',   'native': '日本語',    'flag': '🇯🇵'},
  {'code': 'ko', 'name': 'Korean',     'native': '한국어',    'flag': '🇰🇷'},
  {'code': 'hi', 'name': 'Hindi',      'native': 'हिन्दी',   'flag': '🇮🇳'},
  {'code': 'tr', 'name': 'Turkish',    'native': 'Türkçe',    'flag': '🇹🇷'},
  {'code': 'it', 'name': 'Italian',    'native': 'Italiano',  'flag': '🇮🇹'},
  {'code': 'pt', 'name': 'Portuguese', 'native': 'Português', 'flag': '🇧🇷'},
  {'code': 'ru', 'name': 'Russian',    'native': 'Русский',   'flag': '🇷🇺'},
];
