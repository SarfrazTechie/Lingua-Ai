import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class FeatureRow extends StatelessWidget {
  final String label;
  final bool included;

  const FeatureRow({
    super.key,
    required this.label,
    required this.included,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: included
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.error.withOpacity(0.1),
            ),
            child: Icon(
              included ? Icons.check_rounded : Icons.close_rounded,
              color: included ? AppColors.primary : AppColors.error,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: AppTextStyles.body2.copyWith(
                  color: included
                      ? AppColors.textDarkPrimary
                      : AppColors.textDarkSecondary)),
        ],
      ),
    );
  }
}
