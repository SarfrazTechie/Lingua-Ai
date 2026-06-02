class SupportedLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const SupportedLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

class SupportedLanguages {
  static const List<SupportedLanguage> all = [
    SupportedLanguage(code: 'en', name: 'English',    nativeName: 'English',    flag: '🇬🇧'),
    SupportedLanguage(code: 'es', name: 'Spanish',    nativeName: 'Español',    flag: '🇪🇸'),
    SupportedLanguage(code: 'fr', name: 'French',     nativeName: 'Français',   flag: '🇫🇷'),
    SupportedLanguage(code: 'de', name: 'German',     nativeName: 'Deutsch',    flag: '🇩🇪'),
    SupportedLanguage(code: 'it', name: 'Italian',    nativeName: 'Italiano',   flag: '🇮🇹'),
    SupportedLanguage(code: 'pt', name: 'Portuguese', nativeName: 'Português',  flag: '🇵🇹'),
    SupportedLanguage(code: 'ru', name: 'Russian',    nativeName: 'Русский',    flag: '🇷🇺'),
    SupportedLanguage(code: 'zh', name: 'Chinese',    nativeName: '中文',        flag: '🇨🇳'),
    SupportedLanguage(code: 'ja', name: 'Japanese',   nativeName: '日本語',      flag: '🇯🇵'),
    SupportedLanguage(code: 'ko', name: 'Korean',     nativeName: '한국어',      flag: '🇰🇷'),
    SupportedLanguage(code: 'ar', name: 'Arabic',     nativeName: 'العربية',    flag: '🇸🇦'),
    SupportedLanguage(code: 'hi', name: 'Hindi',      nativeName: 'हिन्दी',     flag: '🇮🇳'),
    SupportedLanguage(code: 'ur', name: 'Urdu',       nativeName: 'اردو',       flag: '🇵🇰'),
    SupportedLanguage(code: 'tr', name: 'Turkish',    nativeName: 'Türkçe',     flag: '🇹🇷'),
    SupportedLanguage(code: 'nl', name: 'Dutch',      nativeName: 'Nederlands', flag: '🇳🇱'),
    SupportedLanguage(code: 'pl', name: 'Polish',     nativeName: 'Polski',     flag: '🇵🇱'),
    SupportedLanguage(code: 'sv', name: 'Swedish',    nativeName: 'Svenska',    flag: '🇸🇪'),
    SupportedLanguage(code: 'da', name: 'Danish',     nativeName: 'Dansk',      flag: '🇩🇰'),
    SupportedLanguage(code: 'fi', name: 'Finnish',    nativeName: 'Suomi',      flag: '🇫🇮'),
    SupportedLanguage(code: 'no', name: 'Norwegian',  nativeName: 'Norsk',      flag: '🇳🇴'),
    SupportedLanguage(code: 'th', name: 'Thai',       nativeName: 'ไทย',        flag: '🇹🇭'),
    SupportedLanguage(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳'),
    SupportedLanguage(code: 'id', name: 'Indonesian', nativeName: 'Indonesia',  flag: '🇮🇩'),
    SupportedLanguage(code: 'ms', name: 'Malay',      nativeName: 'Melayu',     flag: '🇲🇾'),
    SupportedLanguage(code: 'fa', name: 'Persian',    nativeName: 'فارسی',      flag: '🇮🇷'),
  ];

  static SupportedLanguage findByCode(String code) =>
      all.firstWhere((l) => l.code == code,
          orElse: () => all.first);
}
