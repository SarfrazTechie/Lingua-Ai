import 'package:flutter/material.dart';
import '../../app/theme.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.glassDark,
              border: Border.all(color: AppColors.glassBorder),
              boxShadow: AppShadows.glow,
            ),
            child: const Icon(Icons.translate_rounded,
                size: 90, color: AppColors.primary),
          ),
          const SizedBox(height: 48),
          Text('Translate Instantly',
              style: AppTextStyles.headline1
                  .copyWith(color: AppColors.textDarkPrimary),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            'Real-time translation in 100+ languages.\nVoice support & camera translation.',
            style: AppTextStyles.body1
                .copyWith(color: AppColors.textDarkSecondary, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
