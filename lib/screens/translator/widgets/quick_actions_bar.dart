import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class QuickActionsBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const QuickActionsBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final actions = ['Formal', 'Casual', 'Travel', 'Business'];

    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (_, i) {
          final isSelected = selected == actions[i].toLowerCase();
          return GestureDetector(
            onTap: () => onSelected(actions[i].toLowerCase()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.glassBorder,
                ),
              ),
              child: Text(
                actions[i],
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? Colors.black : AppColors.textDarkSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
