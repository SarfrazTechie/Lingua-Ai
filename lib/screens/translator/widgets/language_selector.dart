import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/constants/supported_languages.dart';

class LanguageSelector extends StatelessWidget {
  final String sourceLang;
  final String targetLang;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<String> onTargetChanged;
  final VoidCallback onSwap;

  const LanguageSelector({
    super.key,
    required this.sourceLang,
    required this.targetLang,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.onSwap,
  });

  void _showPicker(BuildContext context, bool isSource) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgDark2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListView.builder(
        itemCount: SupportedLanguages.all.length,
        itemBuilder: (_, i) {
          final lang = SupportedLanguages.all[i];
          return ListTile(
            leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
            title: Text(lang.name,
                style: AppTextStyles.body2
                    .copyWith(color: AppColors.textDarkPrimary)),
            subtitle: Text(lang.nativeName,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textDarkSecondary)),
            onTap: () {
              isSource
                  ? onSourceChanged(lang.code)
                  : onTargetChanged(lang.code);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final source = SupportedLanguages.findByCode(sourceLang);
    final target = SupportedLanguages.findByCode(targetLang);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          // Source
          Expanded(
            child: GestureDetector(
              onTap: () => _showPicker(context, true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.glassDark,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Text(source.flag,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(source.name,
                          style: AppTextStyles.body2.copyWith(
                              color: AppColors.textDarkPrimary,
                              fontWeight: FontWeight.w600)),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textDarkSecondary, size: 18),
                  ],
                ),
              ),
            ),
          ),

          // Swap button
          GestureDetector(
            onTap: onSwap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Icon(Icons.swap_horiz_rounded,
                  color: AppColors.primary, size: 20),
            ),
          ),

          // Target
          Expanded(
            child: GestureDetector(
              onTap: () => _showPicker(context, false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.glassDark,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Text(target.flag,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(target.name,
                          style: AppTextStyles.body2.copyWith(
                              color: AppColors.textDarkPrimary,
                              fontWeight: FontWeight.w600)),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textDarkSecondary, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
