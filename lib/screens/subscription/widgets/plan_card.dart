import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class PlanCard extends StatelessWidget {
  final bool isYearly;
  const PlanCard({super.key, required this.isYearly});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppGradients.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: AppShadows.glow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppGradients.premium,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Row(children: [
                  Icon(Icons.workspace_premium_rounded,
                      color: Colors.black, size: 12),
                  SizedBox(width: 4),
                  Text('Premium Plan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      )),
                ]),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isYearly ? '\$29.99' : '\$9.99',
                style: AppTextStyles.display
                    .copyWith(color: AppColors.textDarkPrimary),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  isYearly ? '/ year' : '/ month',
                  style: AppTextStyles.body2
                      .copyWith(color: AppColors.textDarkSecondary),
                ),
              ),
            ],
          ),
          if (isYearly) ...[
            const SizedBox(height: 4),
            Text('Save 50% vs monthly',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.primary)),
          ],
        ],
      ),
    );
  }
}
