import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class ModeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const ModeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final modes = ['Travel', 'Restaurant', 'Airport', 'Business', 'Casual'];
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: modes.length,
        itemBuilder: (_, i) {
          final isSelected = selected.contains(modes[i]);
          return GestureDetector(
            onTap: () => onSelected(modes[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.glassBorder,
                ),
              ),
              child: Text(modes[i],
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected
                        ? Colors.black
                        : AppColors.textDarkSecondary,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          );
        },
      ),
    );
  }
}
