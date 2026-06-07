import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  final _phoneCtrl       = TextEditingController();
  final _bioCtrl         = TextEditingController();
  final _currentPwCtrl   = TextEditingController();
  final _newPwCtrl       = TextEditingController();
  final _confirmPwCtrl   = TextEditingController();

  bool _obscureCurrent     = true;
  bool _obscureNew         = true;
  bool _obscureConfirm     = true;
  bool _notifTranslations  = true;
  bool _notifUpdates       = false;
  bool _notifTips          = true;
  bool _isSaving           = false;

  // -- Same color helpers as settings_screen ----------------------
  bool get _isDark    => Theme.of(context).brightness == Brightness.dark;
  Color get _bg       => _isDark ? AppColors.bgDark        : AppColors.bgLight;
  Color get _cardBg   => _isDark ? AppColors.cardDark      : AppColors.cardLight;
  Color get _border   => _isDark ? const Color(0xFF2A2A2A) : AppColors.glassBorderLight;
  Color get _textPri  => _isDark ? AppColors.textDarkPrimary   : AppColors.textLightPrimary;
  Color get _textSec  => _isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
  Color get _fill     => _isDark ? const Color(0xFF1A1A1A)     : const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    final user = ref.read(authProvider).value;
    _nameCtrl  = TextEditingController(text: user?.name  ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();    _emailCtrl.dispose();
    _phoneCtrl.dispose();   _bioCtrl.dispose();
    _currentPwCtrl.dispose(); _newPwCtrl.dispose(); _confirmPwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).valueOrNull;
    final initial = (user?.name.isNotEmpty == true) ? user!.name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: _bg,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 195,
            backgroundColor: _bg,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => context.canPop() ? context.pop() : context.go('/settings'),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: _border),
                ),
                child: Icon(Icons.arrow_back_rounded, color: _textPri, size: 20),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: _isSaving ? null : _saveAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 14, height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                        : Text('Save',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      _bg,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 52),
                    Stack(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.primary,
                            boxShadow: AppShadows.glow,
                          ),
                          child: Center(
                            child: Text(initial,
                              style: AppTextStyles.headline1.copyWith(
                                color: Colors.white)),
                          ),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: _bg, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                              size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(user?.name ?? 'User',
                      style: AppTextStyles.headline3.copyWith(color: AppColors.primary)),
                    const SizedBox(height: 2),
                    Text(user?.email ?? '',
                      style: AppTextStyles.caption.copyWith(color: _textSec)),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(46),
              child: Container(
                color: _bg,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: _textSec,
                  labelStyle: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600),
                  unselectedLabelStyle: AppTextStyles.caption,
                  tabs: const [
                    Tab(icon: Icon(Icons.person_outline,        size: 18), text: 'Personal'),
                    Tab(icon: Icon(Icons.lock_outline,           size: 18), text: 'Security'),
                    Tab(icon: Icon(Icons.notifications_outlined, size: 18), text: 'Notifs'),
                    Tab(icon: Icon(Icons.warning_amber_outlined, size: 18), text: 'Danger'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _personalTab(),
            _securityTab(),
            _notifsTab(),
            _dangerTab(),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // TAB 1 — Personal Information + Membership
  // ----------------------------------------------------------------
  Widget _personalTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _card(
          title: 'Personal Information',
          icon: Icons.person_outline_rounded,
          children: [
            _field('Full Name',    _nameCtrl,  Icons.badge_outlined),
            _field('Email',        _emailCtrl, Icons.email_outlined,
                type: TextInputType.emailAddress),
            _field('Phone Number', _phoneCtrl, Icons.phone_outlined,
                type: TextInputType.phone),
            _field('Bio',          _bioCtrl,   Icons.edit_note_rounded,
                maxLines: 3),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _card(
          title: 'Membership',
          icon: Icons.workspace_premium_rounded,
          children: [
            _infoRow('Plan',         'Free Plan',  Icons.star_outline_rounded),
            Divider(height: 1, color: _border),
            _infoRow('Member Since', 'June 2024',  Icons.calendar_today_outlined),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/subscription'),
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: const Text('Upgrade to Pro'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md)),
                  textStyle: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // TAB 2 — Change Password + Sessions + 2FA
  // ----------------------------------------------------------------
  Widget _securityTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _card(
          title: 'Change Password',
          icon: Icons.lock_outline_rounded,
          children: [
            _pwField('Current Password', _currentPwCtrl,
                _obscureCurrent, () => setState(() => _obscureCurrent = !_obscureCurrent)),
            _pwField('New Password', _newPwCtrl,
                _obscureNew,     () => setState(() => _obscureNew     = !_obscureNew)),
            _pwField('Confirm Password', _confirmPwCtrl,
                _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md)),
                  textStyle: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w700),
                ),
                child: const Text('Update Password'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _card(
          title: 'Active Sessions',
          icon: Icons.devices_rounded,
          children: [
            _sessionRow('This Device',      'Android · Current',       true),
            Divider(height: 1, color: _border),
            _sessionRow('Chrome · Windows', 'Lahore, PK · 2 days ago', false),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _card(
          title: 'Two-Factor Authentication',
          icon: Icons.shield_outlined,
          children: [
            Row(children: [
              Icon(Icons.info_outline_rounded, size: 15, color: _textSec),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Add an extra layer of security to your account.',
                  style: AppTextStyles.caption.copyWith(color: _textSec)),
              ),
            ]),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.qr_code_rounded, size: 18),
              label: const Text('Enable 2FA'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md)),
                padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 20),
                textStyle: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // TAB 3 — Notification toggles
  // ----------------------------------------------------------------
  Widget _notifsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _card(
          title: 'Notification Preferences',
          icon: Icons.notifications_outlined,
          children: [
            _notifRow('Translation Alerts',
              'Notify when translation is complete',
              Icons.translate_rounded,
              _notifTranslations,
              (v) => setState(() => _notifTranslations = v)),
            Divider(height: 1, color: _border),
            _notifRow('App Updates',
              'New features and improvements',
              Icons.system_update_outlined,
              _notifUpdates,
              (v) => setState(() => _notifUpdates = v)),
            Divider(height: 1, color: _border),
            _notifRow('Tips & Tricks',
              'Language learning suggestions',
              Icons.lightbulb_outline,
              _notifTips,
              (v) => setState(() => _notifTips = v)),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // TAB 4 — Danger Zone
  // ----------------------------------------------------------------
  Widget _dangerTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.2)),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.warning_amber_rounded,
                  color: AppColors.error.withValues(alpha: 0.85), size: 20),
                const SizedBox(width: 8),
                Text('Danger Zone',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.error, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: AppSpacing.md),
              _dangerRow('Sign Out All Devices',
                'Remove access from all sessions',
                Icons.logout_rounded, AppColors.warning, _signOutAllDevices),
              Divider(height: AppSpacing.lg,
                color: AppColors.error.withValues(alpha: 0.15)),
              _dangerRow('Export My Data',
                'Download a copy of all your data',
                Icons.download_rounded, AppColors.info, () {}),
              Divider(height: AppSpacing.lg,
                color: AppColors.error.withValues(alpha: 0.15)),
              _dangerRow('Delete Account',
                'Permanently delete account and all data',
                Icons.delete_forever_rounded, AppColors.error,
                _confirmDelete),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // REUSABLE WIDGETS
  // ----------------------------------------------------------------

  Widget _card({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: _border),
        boxShadow: _isDark ? [] : AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(title,
              style: AppTextStyles.body2.copyWith(
                color: _textPri, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _field(
    String label, TextEditingController ctrl, IconData icon, {
    TextInputType? type, int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        maxLines: maxLines,
        style: AppTextStyles.body2.copyWith(color: _textPri),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.caption.copyWith(color: _textSec),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          filled: true, fillColor: _fill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(color: _border)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(color: _border)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    );
  }

  Widget _pwField(
    String label, TextEditingController ctrl,
    bool obscure, VoidCallback toggle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        style: AppTextStyles.body2.copyWith(color: _textPri),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.caption.copyWith(color: _textSec),
          prefixIcon: const Icon(Icons.lock_outline_rounded,
            color: AppColors.primary, size: 20),
          suffixIcon: GestureDetector(
            onTap: toggle,
            child: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: _textSec, size: 20)),
          filled: true, fillColor: _fill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(color: _border)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(color: _border)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: AppSpacing.md),
        Text(label,
          style: AppTextStyles.body2.copyWith(color: _textSec)),
        const Spacer(),
        Text(value,
          style: AppTextStyles.body2.copyWith(
            color: _textPri, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _notifRow(
    String title, String subtitle, IconData icon,
    bool value, ValueChanged<bool> onChange,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: AppTextStyles.body2.copyWith(
                color: _textPri, fontWeight: FontWeight.w600)),
            Text(subtitle,
              style: AppTextStyles.caption.copyWith(color: _textSec)),
          ],
        )),
        Switch.adaptive(
          value: value, onChanged: onChange,
          activeColor: AppColors.primary),
      ]),
    );
  }

  Widget _sessionRow(String device, String detail, bool isCurrent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: isCurrent
                ? AppColors.primary.withValues(alpha: 0.1)
                : _fill,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            isCurrent
                ? Icons.smartphone_rounded
                : Icons.computer_rounded,
            color: isCurrent ? AppColors.primary : _textSec,
            size: 18),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device,
              style: AppTextStyles.body2.copyWith(
                color: _textPri, fontWeight: FontWeight.w600)),
            Text(detail,
              style: AppTextStyles.caption.copyWith(color: _textSec)),
          ],
        )),
        if (isCurrent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text('Current',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.w600)),
          )
        else
          GestureDetector(
            onTap: () {},
            child: Text('Revoke',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
      ]),
    );
  }

  Widget _dangerRow(
    String title, String subtitle, IconData icon,
    Color color, VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: AppTextStyles.body2.copyWith(
                color: color, fontWeight: FontWeight.w600)),
            Text(subtitle,
              style: AppTextStyles.caption.copyWith(color: _textSec)),
          ],
        )),
        Icon(Icons.chevron_right_rounded, color: _textSec, size: 18),
      ]),
    );
  }

  // ----------------------------------------------------------------
  // ACTIONS
  // ----------------------------------------------------------------
  Future<void> _saveAll() async {
    setState(() => _isSaving = true);
    try {
      final name = _nameCtrl.text.trim();
      if (name.isNotEmpty) {
        await ref.read(authProvider.notifier).updateName(name);
      }
    } catch (_) {}
    setState(() => _isSaving = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Profile updated successfully'),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md)),
    ));
  }

  Future<void> _changePassword() async {
    if (_newPwCtrl.text != _confirmPwCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Passwords do not match'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
      ));
      return;
    }
    if (_newPwCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Password must be at least 6 characters'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
      ));
      return;
    }
    setState(() => _isSaving = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _newPwCtrl.text.trim()),
      );
      if (mounted) {
        _currentPwCtrl.clear();
        _newPwCtrl.clear();
        _confirmPwCtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Password updated successfully'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
        ));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Failed to update password. Please try again.'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
      ));
    }
    setState(() => _isSaving = false);
  }

  Future<void> _signOutAllDevices() async {
    try {
      await Supabase.instance.client.auth.signOut(scope: SignOutScope.global);
      if (mounted) context.go('/login');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Failed to sign out. Please try again.'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
      ));
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text('Delete Account',
          style: AppTextStyles.headline3.copyWith(color: AppColors.error)),
        content: Text(
          'All your data will be permanently deleted. This cannot be undone.',
          style: AppTextStyles.body2.copyWith(color: _textSec)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
              style: AppTextStyles.body2.copyWith(color: AppColors.primary))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final uid = Supabase.instance.client.auth.currentUser?.id;
                if (uid != null) {
                  await Supabase.instance.client.from('users').delete().eq('uid', uid);
                }
                await Supabase.instance.client.auth.signOut();
                if (mounted) context.go('/login');
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Failed to delete account.'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md)),
                ));
              }
            },
            child: Text('Delete',
              style: AppTextStyles.body2.copyWith(color: AppColors.error))),
        ],
      ),
    );
  }
}






