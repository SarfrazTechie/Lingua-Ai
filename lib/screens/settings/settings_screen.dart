import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _userCard(user?.name, user?.email),
              const SizedBox(height: 24),
              _sectionLabel('General'),
              const SizedBox(height: 10),
              _sectionBox([
                _SettingsTile(
                  icon: Icons.language_rounded,
                  label: 'App Language',
                  value: 'English',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.dark_mode_rounded,
                  label: 'Theme',
                  value: 'Dark',
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 16),
              _sectionLabel('Account'),
              const SizedBox(height: 10),
              _sectionBox([
                _SettingsTile(
                  icon: Icons.star_rounded,
                  label: 'Upgrade to Premium',
                  value: '',
                  onTap: () => context.go('/subscription'),
                  isHighlighted: true,
                ),
                _SettingsTile(
                  icon: Icons.logout_rounded,
                  label: 'Sign Out',
                  value: '',
                  onTap: () async {
                    await ref.read(authProvider.notifier).signOut();
                    if (context.mounted) context.go('/login');
                  },
                  isDestructive: true,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _userCard(String? name, String? email) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x12FFFFFF)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x2600C896),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.person_rounded, color: Color(0xFF00C896), size: 26),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? 'Guest User',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email ?? 'Not signed in',
                style: const TextStyle(
                  color: Color(0x73FFFFFF),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _sectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0x66FFFFFF),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    );
  }

  static Widget _sectionBox(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x12FFFFFF)),
      ),
      child: Column(children: tiles),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isHighlighted;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.isDestructive = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.redAccent
        : isHighlighted
            ? const Color(0xFF00C896)
            : Colors.white;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: const TextStyle(
                  color: Color(0x59FFFFFF),
                  fontSize: 14,
                ),
              ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0x40FFFFFF),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
