import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme.dart';
import '../../../models/translation_model.dart';
import '../../../core/constants/supported_languages.dart';

class OutputCard extends StatelessWidget {
  final TranslationModel translation;

  const OutputCard({super.key, required this.translation});

  @override
  Widget build(BuildContext context) {
    final targetLang = SupportedLanguages.findByCode(translation.targetLang ?? 'en');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Text(targetLang.flag, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(targetLang.name,
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.star_border_rounded,
                      color: AppColors.textDarkSecondary, size: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              translation.translatedText ?? '',
              style: AppTextStyles.body1
                  .copyWith(color: AppColors.textDarkPrimary, height: 1.6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                _ActionIcon(icon: Icons.volume_up_rounded, onTap: () {}),
                const SizedBox(width: 8),
                _ActionIcon(
                  icon: Icons.copy_rounded,
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: translation.translatedText ?? ''));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied!',
                            style: AppTextStyles.body2
                                .copyWith(color: Colors.white)),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _ActionIcon(icon: Icons.share_rounded, onTap: () {}),
                const SizedBox(width: 8),
                _ActionIcon(icon: Icons.favorite_border_rounded, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.glassDark,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, color: AppColors.textDarkSecondary, size: 18),
      ),
    );
  }
}
