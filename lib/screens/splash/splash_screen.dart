import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _globeController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _globeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _globeController, curve: Curves.elasticOut),
    );
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _globeController.forward();
    _fadeController.forward();
    // 4 seconds on splash screen
    await Future.delayed(const Duration(milliseconds: 4000));
    if (mounted) context.go('/onboarding');
  }

  @override
  void dispose() {
    _globeController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.darkBg,
        ),
        child: Stack(
          children: [
            // Glow background
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 120,
                          spreadRadius: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Floating bubbles
            ..._buildBubbles(size),

            // Main content
            FadeTransition(
              opacity: _fadeAnim,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Globe
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: AppShadows.glow,
                        ),
                        child: const Icon(
                          Icons.language_rounded,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // App name
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Lingua',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDarkPrimary,
                              letterSpacing: -1,
                            ),
                          ),
                          TextSpan(
                            text: 'AI',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: -1,
                            ),
                          ),
                          TextSpan(
                            text: ' ✦',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'AI Translator & Chat',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textDarkSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Break language barriers\nwith the power of AI',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textDarkSecondary.withOpacity(0.6),
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 70),

                    // Animated dots
                    AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (context, child) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == 1 ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == 1
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBubbles(Size size) {
    final bubbles = [
      ('Hello', 0.12, 0.12),
      ('Hola', 0.72, 0.18),
      ('你好', 0.08, 0.72),
      ('Bonjour', 0.65, 0.75),
      ('مرحبا', 0.75, 0.45),
    ];

    return bubbles.map((b) {
      return Positioned(
        left: size.width * b.$2,
        top: size.height * b.$3,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.glassDark,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
            ),
            child: Text(
              b.$1,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textDarkPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
