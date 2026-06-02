import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/translation_provider.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
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
  String _sourceLang = 'en';
  String _targetLang = 'es';
  String _selectedTone = 'neutral';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = temp;
    });
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

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.darkBg),
        child: SafeArea(
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
                        color: AppColors.glassDark,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Icon(Icons.menu_rounded,
                          color: AppColors.textDarkPrimary, size: 20),
                    ),
                    RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                          text: 'Lingua',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                        TextSpan(
                          text: 'AI',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppGradients.premium,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: const Row(children: [
                        Icon(Icons.workspace_premium_rounded,
                            color: Colors.black, size: 14),
                        SizedBox(width: 4),
                        Text('Pro', style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 11,
                          fontWeight: FontWeight.w700, color: Colors.black,
                        )),
                      ]),
                    ),
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
                            : _buildEmptyOutput(),
                        loading: () => _buildLoadingOutput(),
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
      ),
    );
  }

  Widget _buildEmptyOutput() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(children: [
        Icon(Icons.translate_rounded,
            color: AppColors.textDarkSecondary.withValues(alpha: 0.4), size: 40),
        const SizedBox(height: 12),
        Text('Translation will appear here',
            style: AppTextStyles.body2
                .copyWith(color: AppColors.textDarkSecondary)),
      ]),
    );
  }

  Widget _buildLoadingOutput() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.glassBorder),
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
