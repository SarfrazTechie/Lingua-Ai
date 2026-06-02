import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  final _emailController = TextEditingController();
  bool _emailSent = false;

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
    super.dispose();
  }

  void _sendReset() {
    setState(() => _emailSent = true);
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 32),

                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.textDarkPrimary, size: 20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Icon
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.glassDark,
                      border: Border.all(color: AppColors.glassBorder),
                      boxShadow: AppShadows.glow,
                    ),
                    child: Icon(
                      _emailSent
                          ? Icons.mark_email_read_outlined
                          : Icons.lock_reset_rounded,
                      size: 44,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    _emailSent ? 'Email Sent!' : 'Forgot Password?',
                    style: AppTextStyles.headline1
                        .copyWith(color: AppColors.textDarkPrimary),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _emailSent
                        ? 'Check your inbox for the\npassword reset link.'
                        : 'Enter your email and we\'ll\nsend you a reset link.',
                    style: AppTextStyles.body2
                        .copyWith(color: AppColors.textDarkSecondary, height: 1.6),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  if (!_emailSent) ...[
                    // Email field
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: AppTextStyles.body2
                            .copyWith(color: AppColors.textDarkPrimary),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: AppTextStyles.body2
                              .copyWith(color: AppColors.textDarkSecondary),
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: AppColors.textDarkSecondary, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Send button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _sendReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                        ),
                        child: Text('Send Reset Link',
                            style: AppTextStyles.button),
                      ),
                    ),
                  ] else ...[
                    // Success animation
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: AppColors.primary, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Reset link sent to\n${_emailController.text}',
                              style: AppTextStyles.body2.copyWith(
                                  color: AppColors.textDarkPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Back to login
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                        ),
                        child: Text('Back to Login',
                            style: AppTextStyles.button),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
