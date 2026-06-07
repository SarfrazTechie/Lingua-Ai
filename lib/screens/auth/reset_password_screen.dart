import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

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
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final newPw = _newPwCtrl.text.trim();
    final confirmPw = _confirmPwCtrl.text.trim();
    if (newPw.isEmpty || confirmPw.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }
    if (newPw != confirmPw) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }
    if (newPw.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPw),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Password updated successfully!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
        ));
        context.go('/login');
      }
    } catch (e) {
      if (mounted) setState(() {
        _errorMessage = 'Failed to update password. Please try again.';
        _isLoading = false;
      });
    }
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Container(
                        width: 42, height: 42,
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
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.glassDark,
                      border: Border.all(color: AppColors.glassBorder),
                      boxShadow: AppShadows.glow,
                    ),
                    child: const Icon(Icons.lock_open_rounded,
                        size: 44, color: AppColors.primary),
                  ),
                  const SizedBox(height: 32),
                  Text('Set New Password',
                      style: AppTextStyles.headline1
                          .copyWith(color: AppColors.textDarkPrimary)),
                  const SizedBox(height: 12),
                  Text('Enter your new password below.',
                      style: AppTextStyles.body2.copyWith(
                          color: AppColors.textDarkSecondary, height: 1.6),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 40),
                  _pwField('New Password', _newPwCtrl, _obscureNew,
                      () => setState(() => _obscureNew = !_obscureNew)),
                  const SizedBox(height: 16),
                  _pwField('Confirm Password', _confirmPwCtrl, _obscureConfirm,
                      () => setState(() => _obscureConfirm = !_obscureConfirm)),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(_errorMessage!,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.error)),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity, height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22, height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black))
                          : const Text('Update Password',
                              style: AppTextStyles.button),
                    ),
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

  Widget _pwField(String label, TextEditingController ctrl,
      bool obscure, VoidCallback toggle) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        style: AppTextStyles.body2.copyWith(color: AppColors.textDarkPrimary),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: AppTextStyles.body2.copyWith(color: AppColors.textDarkSecondary),
          prefixIcon: const Icon(Icons.lock_outline_rounded,
              color: AppColors.textDarkSecondary, size: 20),
          suffixIcon: GestureDetector(
            onTap: toggle,
            child: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.textDarkSecondary, size: 20)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
