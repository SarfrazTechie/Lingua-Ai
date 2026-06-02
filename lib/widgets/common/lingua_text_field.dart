import 'package:flutter/material.dart';
import '../../app/theme.dart';

class LinguaTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscure;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const LinguaTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.prefixIcon,
    this.suffix,
    this.obscure = false,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
              style: AppTextStyles.caption.copyWith(
                  color: AppColors.textDarkSecondary,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: AppTextStyles.body2
                .copyWith(color: AppColors.textDarkPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.body2
                  .copyWith(color: AppColors.textDarkSecondary),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon,
                      color: AppColors.textDarkSecondary, size: 20)
                  : null,
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
