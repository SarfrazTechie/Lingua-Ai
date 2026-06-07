import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/locale_provider.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

// ─── Local Providers ───────────────────────────────────────────────
final _languageProvider = StateProvider<String>((ref) => 'English');
final _speechProvider = StateProvider<String>((ref) => 'Male Voice');
final _notificationsProvider = StateProvider<bool>((ref) => true);

// ─── Main Screen ───────────────────────────────────────────────────
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
    final user = authState.valueOrNull;
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    final selectedLanguage = ref.watch(_languageProvider);
    final selectedSpeech = ref.watch(_speechProvider);
    final notificationsOn = ref.watch(_notificationsProvider);

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
                          : const Icon(Icons.person_rounded, color: AppColors.primary, size: 30),
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
                        onTap: () => context.go('/subscription'),
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
                    value: selectedLanguage,
                    onTap: () => _showLanguagePicker(context, ref, isDark, cardColor, borderColor, textPrimary, textSecondary),
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
                    value: selectedSpeech,
                    onTap: () => _showSpeechPicker(context, ref, isDark, cardColor, borderColor, textPrimary, textSecondary),
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _SettingsTile(
                    icon: Icons.notifications_rounded,
                    label: 'Notifications',
                    value: '',
                    onTap: () => ref.read(_notificationsProvider.notifier).state = !notificationsOn,
                    textPrimary: textPrimary, textSecondary: textSecondary,
                    trailing: Switch(
                      value: notificationsOn,
                      onChanged: (val) => ref.read(_notificationsProvider.notifier).state = val,
                      activeThumbColor: AppColors.primary,
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
                    onTap: () => _showEditProfile(context, ref, user?.name ?? '', isDark, cardColor, borderColor, textPrimary, textSecondary),
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _SettingsTile(
                    icon: Icons.security_rounded,
                    label: 'Privacy & Security',
                    value: '',
                    onTap: () => _showPrivacySecurity(context, isDark, cardColor, borderColor, textPrimary, textSecondary),
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    value: '',
                    onTap: () => _showHelpSupport(context, isDark, cardColor, borderColor, textPrimary, textSecondary),
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: 'About LinguaAI',
                    value: 'Version 1.0.0',
                    onTap: () => _showAbout(context, isDark, cardColor, borderColor, textPrimary, textSecondary),
                    textPrimary: textPrimary, textSecondary: textSecondary,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Sign In / Log Out
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
                      onTap: () => _confirmLogout(context, ref),
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

  // ─── Language Picker ─────────────────────────────────────────────
  void _showLanguagePicker(BuildContext context, WidgetRef ref, bool isDark,
      Color cardColor, Color borderColor, Color textPrimary, Color textSecondary) {
    final languages = [
      'English', 'Urdu', 'Arabic', 'French', 'Spanish',
      'German', 'Chinese', 'Japanese', 'Korean', 'Hindi',
      'Turkish', 'Italian', 'Portuguese', 'Russian',
    ];
    final current = ref.read(_languageProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(2),
            )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Language Preference',
              style: AppTextStyles.headline3.copyWith(color: textPrimary)),
          ),
          Divider(height: 1, color: borderColor),
          SizedBox(
            height: 320,
            child: ListView.separated(
              itemCount: languages.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: borderColor),
              itemBuilder: (_, i) {
                final lang = languages[i];
                final isSelected = lang == current;
                return ListTile(
                  title: Text(lang,
                    style: AppTextStyles.body2.copyWith(
                      color: isSelected ? AppColors.primary : textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    )),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 20)
                      : null,
                  onTap: () {
                    ref.read(_languageProvider.notifier).state = lang;
                    final _codes = {'English':'en','Urdu':'ur','Arabic':'ar','French':'fr','Spanish':'es','German':'de','Chinese':'zh','Japanese':'ja','Korean':'ko','Hindi':'hi','Turkish':'tr','Italian':'it','Portuguese':'pt','Russian':'ru'};
                    ref.read(localeProvider.notifier).setLocale(Locale(_codes[lang] ?? 'en'));
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── Speech Picker ───────────────────────────────────────────────
  void _showSpeechPicker(BuildContext context, WidgetRef ref, bool isDark,
      Color cardColor, Color borderColor, Color textPrimary, Color textSecondary) {
    final options = ['Male Voice', 'Female Voice'];
    final current = ref.read(_speechProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4,
            decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Speech Voice',
              style: AppTextStyles.headline3.copyWith(color: textPrimary)),
          ),
          Divider(height: 1, color: borderColor),
          ...options.map((opt) => Column(
            children: [
              ListTile(
                leading: Icon(
                  opt == 'Male Voice' ? Icons.man_rounded : Icons.woman_rounded,
                  color: opt == current ? AppColors.primary : textSecondary,
                ),
                title: Text(opt,
                  style: AppTextStyles.body2.copyWith(
                    color: opt == current ? AppColors.primary : textPrimary,
                    fontWeight: opt == current ? FontWeight.w600 : FontWeight.normal,
                  )),
                trailing: opt == current
                    ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 20)
                    : null,
                onTap: () {
                  ref.read(_speechProvider.notifier).state = opt;
                  Navigator.pop(context);
                },
              ),
              Divider(height: 1, color: borderColor),
            ],
          )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─── Edit Profile ────────────────────────────────────────────────
  void _showEditProfile(BuildContext context, WidgetRef ref, String currentName,
      bool isDark, Color cardColor, Color borderColor, Color textPrimary, Color textSecondary) {
    final controller = TextEditingController(text: currentName);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text('Edit Profile',
              style: AppTextStyles.headline3.copyWith(color: textPrimary)),
            const SizedBox(height: 16),
            Text('Display Name',
              style: AppTextStyles.caption.copyWith(color: textSecondary)),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              style: AppTextStyles.body2.copyWith(color: textPrimary),
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: AppTextStyles.body2.copyWith(color: textSecondary),
                filled: true,
                fillColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                onPressed: () async {
                  final newName = controller.text.trim();
                  if (newName.isEmpty) return;
                  await ref.read(authProvider.notifier).updateName(newName);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text('Save Changes',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Privacy & Security ──────────────────────────────────────────
  void _showPrivacySecurity(BuildContext context, bool isDark, Color cardColor,
      Color borderColor, Color textPrimary, Color textSecondary) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text('Privacy & Security',
              style: AppTextStyles.headline3.copyWith(color: textPrimary)),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.lock_outline_rounded, label: 'Your data is end-to-end encrypted',
              textPrimary: textPrimary, textSecondary: textSecondary),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.delete_outline_rounded, label: 'Delete Account',
              textPrimary: AppColors.error, textSecondary: textSecondary,
              isDestructive: true),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.history_rounded, label: 'Clear Chat History',
              textPrimary: textPrimary, textSecondary: textSecondary),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─── Help & Support ──────────────────────────────────────────────
  void _showHelpSupport(BuildContext context, bool isDark, Color cardColor,
      Color borderColor, Color textPrimary, Color textSecondary) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text('Help & Support',
              style: AppTextStyles.headline3.copyWith(color: textPrimary)),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.chat_bubble_outline_rounded,
              label: 'Contact Support', textPrimary: textPrimary, textSecondary: textSecondary),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.article_outlined,
              label: 'FAQ', textPrimary: textPrimary, textSecondary: textSecondary),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.star_outline_rounded,
              label: 'Rate LinguaAI', textPrimary: textPrimary, textSecondary: textSecondary),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.share_outlined,
              label: 'Share App', textPrimary: textPrimary, textSecondary: textSecondary),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─── About ───────────────────────────────────────────────────────
  void _showAbout(BuildContext context, bool isDark, Color cardColor,
      Color borderColor, Color textPrimary, Color textSecondary) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Row(
          children: [
            const Icon(Icons.translate_rounded, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Text('LinguaAI',
              style: AppTextStyles.headline3.copyWith(color: textPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0',
              style: AppTextStyles.body2.copyWith(color: textSecondary)),
            const SizedBox(height: 8),
            Text('AI-powered language assistant for translation, conversation, and learning.',
              style: AppTextStyles.caption.copyWith(color: textSecondary)),
            const SizedBox(height: 12),
            Divider(color: borderColor),
            const SizedBox(height: 8),
            Text('Built with Flutter • Firebase • OpenAI',
              style: AppTextStyles.caption.copyWith(color: textSecondary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
              style: AppTextStyles.body2.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  // ─── Logout Confirm ──────────────────────────────────────────────
  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text('Log Out',
          style: AppTextStyles.headline3.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDarkPrimary : AppColors.textLightPrimary)),
        content: Text('Are you sure you want to log out?',
          style: AppTextStyles.body2.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDarkSecondary : AppColors.textLightSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
              style: AppTextStyles.body2.copyWith(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
            child: Text('Log Out',
              style: AppTextStyles.body2.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Widget ────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDestructive;

  const _InfoRow({
    required this.icon, required this.label,
    required this.textPrimary, required this.textSecondary,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: isDestructive ? AppColors.error : AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.body2.copyWith(color: textPrimary)),
      ],
    );
  }
}

// ─── Reused Widgets (unchanged) ───────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color textSecondary;
  const _SectionLabel({required this.label, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Text(label,
      style: AppTextStyles.caption.copyWith(
        color: textSecondary, fontWeight: FontWeight.w600, letterSpacing: 0.8));
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
                Text(value, style: AppTextStyles.caption.copyWith(color: textSecondary)),
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


