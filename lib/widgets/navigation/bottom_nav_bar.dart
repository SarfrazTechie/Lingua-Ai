import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgDark2,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.translate_rounded, label: 'Translator',
              active: currentIndex == 0, onTap: () => context.go('/translator')),
          _NavItem(icon: Icons.smart_toy_rounded, label: 'AI Chat',
              active: currentIndex == 1, onTap: () => context.go('/chat')),
          _NavItem(icon: Icons.history_rounded, label: 'History',
              active: currentIndex == 2, onTap: () => context.go('/history')),
          _NavItem(icon: Icons.bookmark_rounded, label: 'Saved',
              active: currentIndex == 3, onTap: () => context.go('/saved')),
          _NavItem(icon: Icons.settings_rounded, label: 'Settings',
              active: currentIndex == 4, onTap: () => context.go('/settings')),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label,
      required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: active ? AppColors.primary : AppColors.textDarkSecondary,
              size: 22),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.label.copyWith(
              color: active ? AppColors.primary : AppColors.textDarkSecondary)),
        ],
      ),
    );
  }
}
