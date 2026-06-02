import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';

class UpgradePromptSheet extends StatelessWidget {
  final int remaining;
  const UpgradePromptSheet({super.key, required this.remaining});

  static void show(BuildContext context, {int remaining = 0}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgDark2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => UpgradePromptSheet(remaining: remaining),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.premium,
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                color: Colors.black, size: 32),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Daily Limit Reached',
              style: AppTextStyles.headline2
                  .copyWith(color: AppColors.textDarkPrimary)),
          const SizedBox(height: 8),
          Text(
            remaining == 0
                ? 'You\'ve used all your daily AI messages.\nUpgrade to Premium for 500 messages/day!'
                : 'Only $remaining messages left today.\nUpgrade for unlimited access!',
            style: AppTextStyles.body2
                .copyWith(color: AppColors.textDarkSecondary, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/subscription');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              child: Text('Upgrade to Premium',
                  style: AppTextStyles.button),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Maybe later',
                style: AppTextStyles.body2
                    .copyWith(color: AppColors.textDarkSecondary)),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
