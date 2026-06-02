import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import 'widgets/waveform_widget.dart';
import 'widgets/language_pair_bar.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});
  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with TickerProviderStateMixin {
  bool _isListening = false;
  String _sourceLang = 'en';
  String _targetLang = 'es';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() => _isListening = !_isListening);
  }

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
                    const SizedBox(width: 12),
                    Text('Voice Translation',
                        style: AppTextStyles.headline3
                            .copyWith(color: AppColors.textDarkPrimary)),
                  ],
                ),
              ),

              // Language pair bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: LanguagePairBar(
                  sourceLang: _sourceLang,
                  targetLang: _targetLang,
                  onSourceChanged: (l) => setState(() => _sourceLang = l),
                  onTargetChanged: (l) => setState(() => _targetLang = l),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Status text
              Text(
                _isListening ? 'Listening...' : 'Tap to speak',
                style: AppTextStyles.body1.copyWith(
                  color: _isListening
                      ? AppColors.primary
                      : AppColors.textDarkSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Waveform
              Expanded(
                child: Center(
                  child: WaveformWidget(isActive: _isListening),
                ),
              ),

              // Mic button
              Center(
                child: GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, child) => Transform.scale(
                      scale: _isListening ? _pulseAnim.value : 1.0,
                      child: child,
                    ),
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _isListening
                            ? const LinearGradient(
                                colors: [AppColors.error, Color(0xFFFF8C00)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : AppGradients.primary,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening
                                    ? AppColors.error
                                    : AppColors.primary)
                                .withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Auto detect toggle
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.camera_rounded,
                        color: AppColors.textDarkSecondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Auto Detect',
                              style: AppTextStyles.body2.copyWith(
                                  color: AppColors.textDarkPrimary,
                                  fontWeight: FontWeight.w600)),
                          Text('Detect language automatically',
                              style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textDarkSecondary)),
                        ],
                      ),
                    ),
                    Switch(
                      value: true,
                      onChanged: (_) {},
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Bottom Nav
              _buildBottomNav(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgDark2,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.translate_rounded, label: 'Translator', active: false, onTap: () => context.go('/translator')),
          _NavItem(icon: Icons.smart_toy_rounded,  label: 'AI Chat',   active: false, onTap: () => context.go('/chat')),
          _NavItem(icon: Icons.history_rounded,    label: 'History',   active: false, onTap: () => context.go('/history')),
          _NavItem(icon: Icons.bookmark_rounded,   label: 'Saved',     active: false, onTap: () {}),
          _NavItem(icon: Icons.settings_rounded,   label: 'Settings',  active: false, onTap: () {}),
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
