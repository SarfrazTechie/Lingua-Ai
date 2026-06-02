import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/subscription_provider.dart';
import 'widgets/plan_card.dart';
import 'widgets/feature_row.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});
  @override
  ConsumerState<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _isYearly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.darkBg),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/translator'),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.glassDark,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.textDarkPrimary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.sm),

                      // Hero
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppGradients.premium,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withOpacity(0.4),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.workspace_premium_rounded,
                            color: Colors.black, size: 40),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      Text('Upgrade to Premium',
                          style: AppTextStyles.headline1
                              .copyWith(color: AppColors.textDarkPrimary)),

                      const SizedBox(height: 8),

                      Text('Unlock all features and\nsupercharge your experience.',
                          style: AppTextStyles.body2.copyWith(
                              color: AppColors.textDarkSecondary, height: 1.6),
                          textAlign: TextAlign.center),

                      const SizedBox(height: AppSpacing.lg),

                      // Monthly/Yearly toggle
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ToggleBtn(
                              label: 'Monthly',
                              active: !_isYearly,
                              onTap: () => setState(() => _isYearly = false),
                            ),
                            _ToggleBtn(
                              label: 'Yearly  Save 50%',
                              active: _isYearly,
                              onTap: () => setState(() => _isYearly = true),
                              isHighlight: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Plan card
                      PlanCard(isYearly: _isYearly),

                      const SizedBox(height: AppSpacing.lg),

                      // Features
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Column(
                          children: const [
                            FeatureRow(label: 'Unlimited AI Chat', included: true),
                            FeatureRow(label: 'Voice & Camera Translation', included: true),
                            FeatureRow(label: 'Grammar Check', included: true),
                            FeatureRow(label: 'Offline Translation', included: true),
                            FeatureRow(label: 'No Ads', included: true),
                            FeatureRow(label: 'Priority Support', included: true),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // CTA Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            _isYearly
                                ? ref.read(subscriptionProvider.notifier).purchaseYearly()
                                : ref.read(subscriptionProvider.notifier).purchaseMonthly();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                          ),
                          child: Text('Start 7-Day Free Trial',
                              style: AppTextStyles.button),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text('No commitment. Cancel anytime.',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textDarkSecondary)),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool active;
  final bool isHighlight;
  final VoidCallback onTap;

  const _ToggleBtn({
    required this.label,
    required this.active,
    required this.onTap,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(label,
            style: AppTextStyles.caption.copyWith(
              color: active ? Colors.black : AppColors.textDarkSecondary,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}
