import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/constants/supported_languages.dart';

class LanguagePairBar extends StatelessWidget {
  final String sourceLang;
  final String targetLang;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<String> onTargetChanged;

  const LanguagePairBar({
    super.key,
    required this.sourceLang,
    required this.targetLang,
    required this.onSourceChanged,
    required this.onTargetChanged,
  });

  @override
  Widget build(BuildContext context) {
    final source = SupportedLanguages.findByCode(sourceLang);
    final target = SupportedLanguages.findByCode(targetLang);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${source.flag} ${source.name}',
              style: AppTextStyles.body2.copyWith(
                  color: AppColors.textDarkPrimary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          const Icon(Icons.arrow_forward_rounded,
              color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text('${target.flag} ${target.name}',
              style: AppTextStyles.body2.copyWith(
                  color: AppColors.textDarkPrimary,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
