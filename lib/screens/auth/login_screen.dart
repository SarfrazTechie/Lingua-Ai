import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogle() async {
    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
      final state = ref.read(authProvider);
      if (state.hasValue && state.value != null) {
        if (mounted) context.go('/translator');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _handleGuest() async {
    await ref.read(authProvider.notifier).signInAsGuest();
    if (mounted) context.go('/translator');
  }

  Future<void> _handleEmailSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email aur password dalo')),
      );
      return;
    }
    await ref.read(authProvider.notifier).signInWithEmail(email, password);
    final state = ref.read(authProvider);
    if (state.hasValue && state.value != null) {
      if (mounted) context.go('/translator');
    } else if (state.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.darkBg),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: AppShadows.glow,
                    ),
                    child: const Icon(Icons.language_rounded,
                        size: 36, color: Colors.black),
                  ),
                  const SizedBox(height: 24),
                  Text('Welcome Back!',
                      style: AppTextStyles.headline1
                          .copyWith(color: AppColors.textDarkPrimary)),
                  const SizedBox(height: 8),
                  Text('Sign in to continue',
                      style: AppTextStyles.body2
                          .copyWith(color: AppColors.textDarkSecondary)),
                  const SizedBox(height: 40),

                  // Google button
                  _SocialButton(
                    icon: Icons.g_mobiledata_rounded,
                    label: 'Continue with Google',
                    onTap: isLoading ? () {} : _handleGoogle,
                  ),
                  const SizedBox(height: 12),

                  // Apple button
                  _SocialButton(
                    icon: Icons.apple_rounded,
                    label: 'Continue with Apple',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  // Facebook button
                  _SocialButton(
                    icon: Icons.facebook_rounded,
                    label: 'Continue with Facebook',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),

                  Row(children: [
                    const Expanded(child: Divider(color: AppColors.glassBorder)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('or',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textDarkSecondary)),
                    ),
                    const Expanded(child: Divider(color: AppColors.glassBorder)),
                  ]),
                  const SizedBox(height: 24),

                  _buildTextField(
                    controller: _emailController,
                    hint: 'example@gmail.com',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 14),

                  _buildTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textDarkSecondary,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.go('/forgot-password'),
                      child: Text('Forgot?',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleEmailSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('Sign In', style: AppTextStyles.button),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: isLoading ? null : _handleGuest,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textDarkPrimary,
                        side: const BorderSide(color: AppColors.glassBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                      child: Text('Continue as Guest',
                          style: AppTextStyles.button
                              .copyWith(color: AppColors.textDarkPrimary)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text("You can upgrade anytime.",
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textDarkSecondary)),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: AppTextStyles.body2
                              .copyWith(color: AppColors.textDarkSecondary)),
                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: Text('Sign Up',
                            style: AppTextStyles.body2.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: AppTextStyles.body2.copyWith(color: AppColors.textDarkPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.body2
              .copyWith(color: AppColors.textDarkSecondary),
          prefixIcon:
              Icon(icon, color: AppColors.textDarkSecondary, size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textDarkPrimary, size: 24),
            const SizedBox(width: 12),
            Text(label,
                style: AppTextStyles.body2.copyWith(
                    color: AppColors.textDarkPrimary,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
