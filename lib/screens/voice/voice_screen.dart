import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/constants/supported_languages.dart';
import '../../services/voice/voice_service.dart';
import '../../services/ai/translation_service.dart';
import '../../services/firebase/functions_service.dart';
import 'widgets/waveform_widget.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});
  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> with TickerProviderStateMixin {
  final VoiceService _voiceService = VoiceService();
  final FlutterTts _tts = FlutterTts();
  late TranslationService _translationService;

  bool _isListening = false;
  bool _isTranslating = false;
  bool _isSpeaking = false;
  String _sourceLang = 'en';
  String _targetLang = 'es';
  String _spokenText = '';
  String _translatedText = '';
  String _statusText = 'Tap mic to speak';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final Map<String, String> _localeMap = {
    'en': 'en_US', 'es': 'es_ES', 'fr': 'fr_FR', 'de': 'de_DE',
    'ar': 'ar_SA', 'zh': 'zh_CN', 'ja': 'ja_JP', 'ko': 'ko_KR',
    'ur': 'ur_PK', 'hi': 'hi_IN', 'pt': 'pt_BR', 'ru': 'ru_RU',
    'it': 'it_IT', 'tr': 'tr_TR', 'nl': 'nl_NL', 'pl': 'pl_PL',
    'sv': 'sv_SE', 'da': 'da_DK', 'fi': 'fi_FI', 'no': 'no_NO',
    'th': 'th_TH', 'vi': 'vi_VN', 'id': 'id_ID', 'ms': 'ms_MY',
    'fa': 'fa_IR',
  };

  @override
  void initState() {
    super.initState();
    _translationService = TranslationService(FunctionsService());
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    _tts.setCompletionHandler(() {
      if (mounted) setState(() { _isSpeaking = false; _statusText = 'Tap mic to speak'; });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _voiceService.stopListening();
    _tts.stop();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = temp;
      _spokenText = '';
      _translatedText = '';
      _statusText = 'Tap mic to speak';
    });
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() { _isListening = false; _statusText = 'Tap mic to speak'; });
      return;
    }

    final hasPermission = await _voiceService.requestMicPermission();
    if (!hasPermission) {
      setState(() => _statusText = 'Microphone permission denied');
      return;
    }

    setState(() {
      _isListening = true;
      _spokenText = '';
      _translatedText = '';
      _statusText = 'Listening...';
    });

    await _voiceService.startListening(
      localeId: _localeMap[_sourceLang] ?? 'en_US',
      onResult: (text) {
        if (mounted) setState(() => _spokenText = text);
      },
      onDone: () async {
        if (!mounted) return;
        setState(() {
          _isListening = false;
          _isTranslating = true;
          _statusText = 'Translating...';
        });
        await _translateAndSpeak();
      },
    );
  }

  Future<void> _translateAndSpeak() async {
    if (_spokenText.trim().isEmpty) {
      setState(() { _isTranslating = false; _statusText = 'Tap mic to speak'; });
      return;
    }
    try {
      final translated = await _translationService.translate(
        text: _spokenText,
        sourceLang: _sourceLang,
        targetLang: _targetLang,
      );
      if (!mounted) return;
      setState(() {
        _translatedText = translated;
        _isTranslating = false;
        _isSpeaking = true;
        _statusText = 'Speaking...';
      });
      await _tts.setLanguage(_targetLang);
      await _tts.speak(translated);
    } catch (e) {
      if (!mounted) return;
      setState(() { _isTranslating = false; _statusText = 'Translation failed. Try again.'; });
    }
  }

  Future<void> _speakAgain() async {
    if (_translatedText.isEmpty || _isSpeaking) return;
    setState(() { _isSpeaking = true; _statusText = 'Speaking...'; });
    await _tts.setLanguage(_targetLang);
    await _tts.speak(_translatedText);
  }

  void _showLangPicker(bool isSource) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: SupportedLanguages.all.map((lang) {
          final selected = isSource ? lang.code == _sourceLang : lang.code == _targetLang;
          return ListTile(
            leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
            title: Text(lang.name,
                style: AppTextStyles.body2.copyWith(
                  color: selected ? AppColors.primary
                      : (isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                )),
            subtitle: Text(lang.nativeName,
                style: AppTextStyles.caption.copyWith(
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                )),
            trailing: selected ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
            onTap: () {
              setState(() {
                if (isSource) _sourceLang = lang.code;
                else _targetLang = lang.code;
                _spokenText = '';
                _translatedText = '';
                _statusText = 'Tap mic to speak';
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDark : AppColors.bgLight;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor = isDark ? AppColors.glassBorder : AppColors.glassBorderLight;
    final textPrimary = isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final textSecondary = isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
    final navBg = isDark ? AppColors.bgDark2 : AppColors.cardLight;
    final navBorder = isDark ? AppColors.glassBorder : AppColors.glassBorderLight;
    final backBg = isDark ? AppColors.glassDark : AppColors.cardLight2;

    final sourceLang = SupportedLanguages.findByCode(_sourceLang);
    final targetLang = SupportedLanguages.findByCode(_targetLang);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/translator'),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: backBg,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(Icons.arrow_back_rounded, color: textPrimary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Voice Translation',
                      style: AppTextStyles.headline3.copyWith(color: textPrimary)),
                ],
              ),
            ),

            // Language Selector with Swap
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: borderColor),
                  boxShadow: isDark ? [] : AppShadows.card,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showLangPicker(true),
                        child: Column(
                          children: [
                            Text(sourceLang.flag, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 2),
                            Text(sourceLang.name,
                                style: AppTextStyles.caption.copyWith(
                                    color: textPrimary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _swapLanguages,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.swap_horiz_rounded,
                            color: AppColors.primary, size: 22),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showLangPicker(false),
                        child: Column(
                          children: [
                            Text(targetLang.flag, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 2),
                            Text(targetLang.name,
                                style: AppTextStyles.caption.copyWith(
                                    color: textPrimary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Status
            Text(
              _statusText,
              style: AppTextStyles.body1.copyWith(
                color: _isListening ? AppColors.primary : textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Waveform
            SizedBox(
              height: 80,
              child: Center(child: WaveformWidget(isActive: _isListening)),
            ),

            const SizedBox(height: AppSpacing.md),

            // Spoken text
            if (_spokenText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: borderColor),
                    boxShadow: isDark ? [] : AppShadows.card,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${sourceLang.flag} ${sourceLang.name}',
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(_spokenText,
                          style: AppTextStyles.body2.copyWith(color: textPrimary)),
                    ],
                  ),
                ),
              ),

            if (_spokenText.isNotEmpty) const SizedBox(height: AppSpacing.sm),

            // Translated text
            if (_translatedText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text('${targetLang.flag} ${targetLang.name}',
                                style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ),
                          GestureDetector(
                            onTap: _speakAgain,
                            child: Icon(
                              _isSpeaking ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                              color: AppColors.primary, size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(_translatedText,
                          style: AppTextStyles.body2.copyWith(color: textPrimary)),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Mic Button
            Center(
              child: GestureDetector(
                onTap: _isTranslating ? null : _toggleListening,
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, child) => Transform.scale(
                    scale: _isListening ? _pulseAnim.value : 1.0,
                    child: child,
                  ),
                  child: Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _isTranslating
                          ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                          : _isListening
                              ? const LinearGradient(
                                  colors: [AppColors.error, Color(0xFFFF8C00)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : AppGradients.primary,
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? AppColors.error : AppColors.primary).withOpacity(0.4),
                          blurRadius: 24, spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: _isTranslating
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Icon(
                            _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                            color: Colors.black, size: 40,
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Bottom Nav
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: navBg,
                border: Border(top: BorderSide(color: navBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(icon: Icons.translate_rounded, label: 'Translator', active: false, onTap: () => context.go('/translator'), isDark: isDark),
                  _NavItem(icon: Icons.smart_toy_rounded, label: 'AI Chat', active: false, onTap: () => context.go('/chat'), isDark: isDark),
                  _NavItem(icon: Icons.history_rounded, label: 'History', active: false, onTap: () => context.go('/history'), isDark: isDark),
                  _NavItem(icon: Icons.bookmark_rounded, label: 'Saved', active: false, onTap: () => context.go('/saved'), isDark: isDark),
                  _NavItem(icon: Icons.settings_rounded, label: 'Settings', active: false, onTap: () => context.go('/settings'), isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label,
      required this.active, required this.onTap, required this.isDark});
  @override
  Widget build(BuildContext context) {
    final inactiveColor = isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? AppColors.primary : inactiveColor, size: 22),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.label.copyWith(
              color: active ? AppColors.primary : inactiveColor)),
        ],
      ),
    );
  }
}


