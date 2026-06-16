import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/translator/translator_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/voice/voice_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/subscription/subscription_screen.dart';
import '../screens/saved/saved_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/camera/camera_screen.dart';
import '../screens/profile/edit_profile_screen.dart';

final _publicRoutes = ['/', '/onboarding', '/login', '/register', '/forgot-password', '/reset-password'];

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = Supabase.instance.client.auth.currentUser;
    final isAuth = user != null;
    if (!isAuth && !_publicRoutes.contains(state.matchedLocation)) {
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', name: 'splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboarding', name: 'onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', name: 'register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/forgot-password', name: 'forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(path: '/reset-password', name: 'reset-password', builder: (context, state) => const ResetPasswordScreen()),
    GoRoute(path: '/home', name: 'home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/translator', name: 'translator', builder: (context, state) => const TranslatorScreen()),
    GoRoute(path: '/chat', name: 'chat', builder: (context, state) => const ChatScreen()),
    GoRoute(path: '/voice', name: 'voice', builder: (context, state) => const VoiceScreen()),
    GoRoute(path: '/history', name: 'history', builder: (context, state) => const HistoryScreen()),
    GoRoute(path: '/subscription', name: 'subscription', builder: (context, state) => const SubscriptionScreen()),
    GoRoute(path: '/saved', name: 'saved', builder: (context, state) => const SavedScreen()),
    GoRoute(path: '/settings', name: 'settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/camera', name: 'camera', builder: (context, state) => const CameraScreen()),
    GoRoute(path: '/edit-profile', name: 'edit-profile', builder: (context, state) => const EditProfileScreen()),
  ],
);
