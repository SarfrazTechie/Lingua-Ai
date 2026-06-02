import 'package:flutter/material.dart';
import '../../app/theme.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});
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
            child: const Icon(Icons.smart_toy_rounded,
                size: 90, color: AppColors.primary),
          ),
          const SizedBox(height: 48),
          Text('AI Conversation',
              style: AppTextStyles.headline1
                  .copyWith(color: AppColors.textDarkPrimary),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            'Practice with AI tutor in any scenario.\nTravel, business, accent coaching.',
            style: AppTextStyles.body1
                .copyWith(color: AppColors.textDarkSecondary, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
