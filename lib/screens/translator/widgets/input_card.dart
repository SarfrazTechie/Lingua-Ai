import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';

class InputCard extends StatelessWidget {
  final TextEditingController controller;
  final String sourceLang;
  final VoidCallback onTranslate;
  final VoidCallback onVoice;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const InputCard({
    super.key,
    required this.controller,
    required this.sourceLang,
    required this.onTranslate,
    required this.onVoice,
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor = isDark ? const Color(0xFF2A2A2A) : AppColors.glassBorderLight;
    final textColor = isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final hintColor = isDark ? AppColors.textDarkTertiary : AppColors.textLightTertiary;
    final iconBg = isDark ? AppColors.bgDark3 : AppColors.cardLight2;
    final iconColor = isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Text(
              sourceLang.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          TextField(
            controller: controller,
            maxLines: 5,
            maxLength: AppConstants.maxTranslationChars,
            style: AppTextStyles.body1.copyWith(color: textColor, height: 1.6),
            decoration: InputDecoration(
              hintText: 'Enter text to translate...',
              hintStyle: AppTextStyles.body1.copyWith(color: hintColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              counterStyle: AppTextStyles.caption.copyWith(color: iconColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Row(
              children: [
                _ActionIcon(icon: Icons.mic_rounded, onTap: onVoice, bg: iconBg, color: iconColor),
                const SizedBox(width: 8),
                _ActionIcon(icon: Icons.volume_up_rounded, onTap: () {}, bg: iconBg, color: iconColor),
                const SizedBox(width: 8),
                _ActionIcon(icon: Icons.camera_alt_rounded, onTap: onCamera, bg: iconBg, color: iconColor),
                const Spacer(),
                GestureDetector(
                  onTap: onTranslate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: AppShadows.button,
                    ),
                    child: Text('Translate',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      )),
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
  final Color bg;
  final Color color;

  const _ActionIcon({required this.icon, required this.onTap, required this.bg, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
