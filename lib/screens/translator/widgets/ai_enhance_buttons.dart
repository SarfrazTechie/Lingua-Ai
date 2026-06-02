import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class AiEnhanceButtons extends StatelessWidget {
  final ValueChanged<String> onTap;

  const AiEnhanceButtons({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.info_outline_rounded, 'Explain'),
      (Icons.spellcheck_rounded, 'Grammar'),
      (Icons.public_rounded, 'Cultural'),
      (Icons.auto_fix_high_rounded, 'Rephrase'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AI Enhance',
            style: AppTextStyles.caption.copyWith(
                color: AppColors.textDarkSecondary,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(
          children: actions.map((a) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(a.$2),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    children: [
                      Icon(a.$1, color: AppColors.primary, size: 18),
                      const SizedBox(height: 4),
                      Text(a.$2,
                          style: AppTextStyles.label.copyWith(
                              color: AppColors.textDarkSecondary)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
