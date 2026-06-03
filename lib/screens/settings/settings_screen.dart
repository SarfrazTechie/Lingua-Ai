import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDark : AppColors.bgLight;
    final textPrimary = isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final textSecondary = isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor = isDark ? const Color(0xFF2A2A2A) : AppColors.glassBorderLight;

    final authState = ref.watch(authProvider);
    final user = authState.value;
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
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
                      color: cardColor,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: borderColor),
                    ),
                    child: Icon(Icons.menu_rounded, color: textPrimary, size: 20),
                  ),
                  Text('Profile',
                    style: AppTextStyles.headline3.copyWith(color: textPrimary)),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // User Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: borderColor),
                  boxShadow: isDark ? [] : AppShadows.card,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: user?.photoUrl != null
                          ? ClipOval(child: Image.network(user!.photoUrl!, fit: BoxFit.cover))
                          : Icon(Icons.person_rounded, color: AppColors.primary, size: 30),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name.isNotEmpty == true ? user!.name : 'Guest User',
                            style: AppTextStyles.headline3.copyWith(color: textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email.isNotEmpty == true ? user!.email : 'Not signed in',
                            style: AppTextStyles.caption.copyWith(color: textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: user?.isPremium == true
                                  ? AppColors.gold.withValues(alpha: 0.15)
                                  : AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              user?.isPremium == true ? '👑 Premium Plan' : 'Free Plan',
                              style: AppTextStyles.caption.copyWith(
                                color: user?.isPremium == true ? AppColors.gold : AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (user != null)
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                          ),
                          child: Text('Manage',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary, fontWeight: FontWeight.w600,
                            )),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // My Plan
              _SectionLabel(label: 'My Plan', textSecondary: textSecondary),
              const SizedBox(height: AppSpacing.sm),
              _SettingsCard(
                isDark: isDark, cardColor: cardColor, borderColor: borderColor,
                children: [
                  _SettingsTile(
                    icon: Icons.workspace_premium_rounded,
                    label: 'My Plan',
                    value: user?.isPremium == true ? 'Premium' : 'Free',
                    onTap: () => context.go('/subscription'),
                    textPrimary: textPrimary, textSecondary: textSecondary,
                    iconColor: AppColors.gold,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // General
              _SectionLabel(label: 'General', textSecondary: textSecondary),
              const SizedBox(height: AppSpacing.sm),
              _SettingsCard(
                isDark: isDark, cardColor: cardColor, borderColor: borderColor,
                children: [
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    label: 'Language Preference',
                    value: 'English',
                    onTap: () {},
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _ThemeTile(
                    isDark: isDark,
                    isDarkMode: isDarkMode,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onToggle: () => ref.read(themeModeProvider.notifier).toggleTheme(),
                  ),
                  Divider(height: 1, color: borderColor),
                  _SettingsTile(
                    icon: Icons.record_voice_over_rounded,
                    label: 'Speech',
                    value: 'Male Voice',
                    onTap: () {},
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _SettingsTile(
                    icon: Icons.notifications_rounded,
                    label: 'Notifications',
                    value: '',
                    onTap: () {},
                    textPrimary: textPrimary, textSecondary: textSecondary,
                    trailing: Switch(
                      value: true,
                      onChanged: (_) {},
                      activeColor: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Account
              _SectionLabel(label: 'Account', textSecondary: textSecondary),
              const SizedBox(height: AppSpacing.sm),
              _SettingsCard(
                isDark: isDark, cardColor: cardColor, borderColor: borderColor,
                children: [
                  _SettingsTile(
                    icon: Icons.edit_rounded,
                    label: 'Edit Profile',
                    value: '',
                    onTap: () {},
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _SettingsTile(
                    icon: Icons.security_rounded,
                    label: 'Privacy & Security',
                    value: '',
                    onTap: () {},
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    value: '',
                    onTap: () {},
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: 'About LinguaAI',
                    value: 'Version 1.0.0',
                    onTap: () {},
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Sign Out
              _SettingsCard(
                isDark: isDark, cardColor: cardColor, borderColor: borderColor,
                children: [
                  if (user == null)
                    _SettingsTile(
                      icon: Icons.login_rounded,
                      label: 'Sign In',
                      value: '',
                      onTap: () => context.go('/login'),
                      textPrimary: AppColors.primary, textSecondary: textSecondary,
                      iconColor: AppColors.primary,
                    )
                  else
                    _SettingsTile(
                      icon: Icons.logout_rounded,
                      label: 'Log Out',
                      value: '',
                      onTap: () async {
                        await ref.read(authProvider.notifier).signOut();
                        if (context.mounted) context.go('/login');
                      },
                      textPrimary: AppColors.error, textSecondary: textSecondary,
                      iconColor: AppColors.error,
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color textSecondary;
  const _SectionLabel({required this.label, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Text(label,
      style: AppTextStyles.caption.copyWith(
        color: textSecondary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ));
  }
}

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color borderColor;
  final List<Widget> children;
  const _SettingsCard({
    required this.isDark, required this.cardColor,
    required this.borderColor, required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : AppShadows.card,
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Color textPrimary;
  final Color textSecondary;
  final Color? iconColor;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon, required this.label, required this.value,
    required this.onTap, required this.textPrimary, required this.textSecondary,
    this.iconColor, this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label,
                style: AppTextStyles.body2.copyWith(
                  color: textPrimary, fontWeight: FontWeight.w500)),
            ),
            if (trailing != null) trailing!
            else ...[
              if (value.isNotEmpty)
                Text(value,
                  style: AppTextStyles.caption.copyWith(color: textSecondary)),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: textSecondary, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final bool isDark;
  final bool isDarkMode;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onToggle;

  const _ThemeTile({
    required this.isDark, required this.isDarkMode,
    required this.textPrimary, required this.textSecondary,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
      child: Row(
        children: [
          Icon(isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text('Theme',
              style: AppTextStyles.body2.copyWith(
                color: textPrimary, fontWeight: FontWeight.w500)),
          ),
          Text(isDarkMode ? 'Dark' : 'Light',
            style: AppTextStyles.caption.copyWith(color: textSecondary)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Text(isDarkMode ? 'Switch to Light' : 'Switch to Dark',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
