import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';

class InputCard extends StatelessWidget {
  final TextEditingController controller;
  final String sourceLang;
  final VoidCallback onTranslate;
  final VoidCallback onVoice;

  const InputCard({
    super.key,
    required this.controller,
    required this.sourceLang,
    required this.onTranslate,
    required this.onVoice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text('English',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
          TextField(
            controller: controller,
            maxLines: 4,
            maxLength: AppConstants.maxTranslationChars,
            style: AppTextStyles.body1
                .copyWith(color: AppColors.textDarkPrimary),
            decoration: InputDecoration(
              hintText: 'Enter text to translate...',
              hintStyle: AppTextStyles.body1
                  .copyWith(color: AppColors.textDarkSecondary.withOpacity(0.5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterStyle: AppTextStyles.caption
                  .copyWith(color: AppColors.textDarkSecondary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                _ActionIcon(
                    icon: Icons.mic_rounded,
                    onTap: onVoice),
                const SizedBox(width: 8),
                _ActionIcon(
                    icon: Icons.volume_up_rounded,
                    onTap: () {}),
                const SizedBox(width: 8),
                _ActionIcon(
                    icon: Icons.camera_alt_rounded,
                    onTap: () {}),
                const Spacer(),
                GestureDetector(
                  onTap: onTranslate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: AppShadows.button,
                    ),
                    child: Text('Translate',
                        style: AppTextStyles.caption.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
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
