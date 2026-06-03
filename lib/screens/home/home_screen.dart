import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/history_provider.dart';
import '../../models/translation_model.dart';
import '../../core/constants/supported_languages.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDark : AppColors.bgLight;
    final textPrimary = isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final textSecondary = isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor = isDark ? const Color(0xFF2A2A2A) : AppColors.glassBorderLight;
    final menuBg = isDark ? AppColors.cardDark : AppColors.cardLight;

    final authState = ref.watch(authProvider);
    final user = authState.value;
    final userName = user == null
        ? 'Guest'
        : user.name.isNotEmpty
            ? user.name.split(' ').first
            : 'User';

    final historyState = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: menuBg,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: borderColor),
                    ),
                    child: Icon(Icons.menu_rounded, color: textPrimary, size: 20),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Lingua',
                        style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 20,
                          fontWeight: FontWeight.w700, color: textPrimary,
                        ),
                      ),
                      const TextSpan(
                        text: 'AI',
                        style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 20,
                          fontWeight: FontWeight.w700, color: AppColors.primary,
                        ),
                      ),
                    ]),
                  ),
                  Text(String.fromCharCode(0x1F451), style: const TextStyle(fontSize: 24)),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Greeting
              Text(
                'Hello, $userName! \u{1F44B}',
                style: AppTextStyles.headline1.copyWith(color: textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                user == null
                    ? 'Sign in to save your history'
                    : 'What would you like to do today?',
                style: AppTextStyles.body2.copyWith(color: textSecondary),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Feature Cards
              Row(
                children: [
                  Expanded(
                    child: _FeatureCard(
                      title: 'Translator',
                      subtitle: 'Translate text, voice or conversation',
                      color: const Color(0xFF00C896),
                      bgColor: isDark ? const Color(0xFF0D2B22) : const Color(0xFFE6FAF5),
                      icon: Icons.translate_rounded,
                      onTap: () => context.go('/translator'),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _FeatureCard(
                      title: 'AI Chat',
                      subtitle: 'Chat with AI in any scenario',
                      color: const Color(0xFF3B82F6),
                      bgColor: isDark ? const Color(0xFF0D1B2B) : const Color(0xFFE6F0FF),
                      icon: Icons.chat_bubble_outline_rounded,
                      onTap: () => context.go('/chat'),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Quick Actions
              Text('Quick Actions',
                style: AppTextStyles.headline3.copyWith(color: textPrimary)),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickAction(icon: Icons.mic_rounded, label: 'Voice\nTranslation',
                    onTap: () => context.go('/voice'), isDark: isDark),
                  _QuickAction(icon: Icons.camera_alt_rounded, label: 'Camera\nTranslation',
                    onTap: () {}, isDark: isDark),
                  _QuickAction(icon: Icons.forum_rounded, label: 'Conversation\nPractice',
                    onTap: () {}, isDark: isDark),
                  _QuickAction(icon: Icons.spellcheck_rounded, label: 'Grammar\nCheck',
                    onTap: () {}, isDark: isDark),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Recent Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent',
                    style: AppTextStyles.headline3.copyWith(color: textPrimary)),
                  TextButton(
                    onPressed: () => context.go('/history'),
                    child: Text('See all >',
                      style: AppTextStyles.body2.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              historyState.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  ),
                ),
                error: (e, _) => Center(
                  child: Text('Could not load history',
                    style: AppTextStyles.body2.copyWith(color: textSecondary)),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(children: [
                        Icon(Icons.history_rounded,
                          color: textSecondary.withValues(alpha: 0.4), size: 36),
                        const SizedBox(height: 8),
                        Text(
                          user == null
                              ? 'Sign in to see your history'
                              : 'No translations yet',
                          style: AppTextStyles.body2.copyWith(color: textSecondary),
                        ),
                      ]),
                    );
                  }
                  final recent = items.take(3).toList();
                  return Column(
                    children: recent.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _RecentItem(
                        item: item,
                        cardColor: cardColor,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    )).toList(),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title,
              style: AppTextStyles.headline3.copyWith(
                color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
              )),
            const SizedBox(height: 4),
            Text(subtitle,
              style: AppTextStyles.caption.copyWith(
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                height: 1.4,
              )),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text('Open',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w600,
                )),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? const Color(0xFF2A2A2A) : AppColors.glassBorderLight;
    final textColor = isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: border),
              boxShadow: isDark ? [] : AppShadows.card,
            ),
            child: Icon(icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: textColor, height: 1.3)),
        ],
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final TranslationModel item;
  final Color cardColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _RecentItem({
    required this.item,
    required this.cardColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final sourceLang = SupportedLanguages.findByCode(item.sourceLang ?? 'en');
    final targetLang = SupportedLanguages.findByCode(item.targetLang ?? 'en');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                Text(sourceLang.flag, style: const TextStyle(fontSize: 16)),
                const Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.primary),
                Text(targetLang.flag, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.sourceText ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body2.copyWith(
                    color: textPrimary, fontWeight: FontWeight.w500)),
                Text(
                  '${sourceLang.name} \u2192 ${targetLang.name}',
                  style: AppTextStyles.caption.copyWith(color: textSecondary)),
              ],
            ),
          ),
          Icon(
            (item.isSaved ?? false) ? Icons.star_rounded : Icons.star_border_rounded,
            color: (item.isSaved ?? false) ? AppColors.gold : textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
