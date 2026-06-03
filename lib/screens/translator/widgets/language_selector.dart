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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.bgDark2 : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.textDarkTertiary : AppColors.textLightTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Select Language',
              style: AppTextStyles.headline3.copyWith(
                color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
              )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: SupportedLanguages.all.length,
              itemBuilder: (_, i) {
                final lang = SupportedLanguages.all[i];
                return ListTile(
                  leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(lang.name,
                    style: AppTextStyles.body2.copyWith(
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                      fontWeight: FontWeight.w500,
                    )),
                  subtitle: Text(lang.nativeName,
                    style: AppTextStyles.caption.copyWith(
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    )),
                  onTap: () {
                    isSource ? onSourceChanged(lang.code) : onTargetChanged(lang.code);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final source = SupportedLanguages.findByCode(sourceLang);
    final target = SupportedLanguages.findByCode(targetLang);

    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor = isDark ? const Color(0xFF2A2A2A) : AppColors.glassBorderLight;
    final chipColor = isDark ? AppColors.bgDark3 : AppColors.cardLight2;
    final textColor = isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final subTextColor = isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;

    return Container(
      padding: const EdgeInsets.all(6),
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
              onTap: () => _showPicker(context, true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Text(source.flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(source.name,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body2.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        )),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, color: subTextColor, size: 18),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onSwap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: AppShadows.button,
              ),
              child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 20),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _showPicker(context, false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Text(target.flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(target.name,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body2.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        )),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, color: subTextColor, size: 18),
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
