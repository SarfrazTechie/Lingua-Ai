import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/translation_provider.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../services/ai/image_translation_service.dart';
import 'widgets/language_selector.dart';
import 'widgets/input_card.dart';
import 'widgets/output_card.dart';
import 'widgets/quick_actions_bar.dart';
import 'widgets/ai_enhance_buttons.dart';

class TranslatorScreen extends ConsumerStatefulWidget {
  const TranslatorScreen({super.key});
  @override
  ConsumerState<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends ConsumerState<TranslatorScreen> {
  final _textController = TextEditingController();
  final _imageService = ImageTranslationService();
  String _sourceLang = 'en';
  String _targetLang = 'es';
  String _selectedTone = 'neutral';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouterState.of(context).uri;
      if (uri.queryParameters['openCamera'] == 'true') {
        _handleCamera();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _imageService.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = temp;
    });
  }

  Future<void> _handleCamera() async {
    final extractedText = await context.push<String>('/camera');
    if (extractedText != null && extractedText.isNotEmpty && mounted) {
      _textController.text = extractedText;
      _translate();
    }
  }

  void _translate() {
    if (_textController.text.trim().isEmpty) return;
    ref.read(translationProvider.notifier).translate(
          text: _textController.text.trim(),
          sourceLang: _sourceLang,
          targetLang: _targetLang,
          tone: _selectedTone,
        );
  }

  @override
  Widget build(BuildContext context) {
    final translationState = ref.watch(translationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDark : AppColors.bgLight;
    final textPrimary = isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final menuBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final menuBorder = isDark ? const Color(0xFF2A2A2A) : AppColors.glassBorderLight;

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: menuBg,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: menuBorder),
                    ),
                    child: Icon(Icons.menu_rounded, color: textPrimary, size: 20),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Lingua',
                        style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const TextSpan(
                        text: 'AI',
                        style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ]),
                  ),
                  Text(String.fromCharCode(0x1F451),
                      style: const TextStyle(fontSize: 24)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    LanguageSelector(
                      sourceLang: _sourceLang,
                      targetLang: _targetLang,
                      onSourceChanged: (l) => setState(() => _sourceLang = l),
                      onTargetChanged: (l) => setState(() => _targetLang = l),
                      onSwap: _swapLanguages,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InputCard(
                      controller: _textController,
                      sourceLang: _sourceLang,
                      onTranslate: _translate,
                      onVoice: () => context.go('/voice'),
                      onCamera: _handleCamera,
                      onGallery: () {},
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    QuickActionsBar(
                      selected: _selectedTone,
                      onSelected: (tone) {
                        setState(() => _selectedTone = tone);
                        _translate();
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    translationState.when(
                      data: (translation) => translation != null
                          ? OutputCard(translation: translation)
                          : _buildEmptyOutput(isDark),
                      loading: () => _buildLoadingOutput(isDark),
                      error: (e, _) => _buildErrorOutput(e.toString()),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (translationState.value != null)
                      AiEnhanceButtons(onTap: (action) {}),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyOutput(bool isDark) {
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor =
        isDark ? const Color(0xFF2A2A2A) : AppColors.glassBorderLight;
    final iconColor =
        isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : AppShadows.card,
      ),
      child: Column(children: [
        Icon(Icons.translate_rounded,
            color: iconColor.withValues(alpha: 0.4), size: 40),
        const SizedBox(height: 12),
        Text('Translation will appear here',
            style: AppTextStyles.body2.copyWith(color: iconColor)),
      ]),
    );
  }

  Widget _buildLoadingOutput(bool isDark) {
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor =
        isDark ? const Color(0xFF2A2A2A) : AppColors.glassBorderLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: const Center(
        child: CircularProgressIndicator(
            color: AppColors.primary, strokeWidth: 2),
      ),
    );
  }

  Widget _buildErrorOutput(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Text('Error: $error',
          style: AppTextStyles.body2.copyWith(color: AppColors.error)),
    );
  }
}
