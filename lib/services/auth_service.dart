import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../core/errors/app_exception.dart';

class AuthService {
  final _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '1055525036473-15je998co5au4jrjtjemi3k5rqpkd5q0.apps.googleusercontent.com',
    forceCodeForRefreshToken: true,
  );

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      try {
        final data = await _supabase
            .from('users')
            .select()
            .eq('uid', user.id)
            .single();
        return UserModel.fromMap(data);
      } catch (_) {
        return UserModel(
          uid: user.id,
          name: user.userMetadata?['name'] ?? 'User',
          email: user.email ?? '',
          preferredLanguage: 'en',
          isPremium: false,
          createdAt: DateTime.now(),
        );
      }
    } catch (_) {
      return null;
    }
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return await getCurrentUser() ??
          UserModel(
            uid: response.user!.id,
            name: response.user!.userMetadata?['name'] ?? 'User',
            email: response.user!.email ?? '',
            preferredLanguage: 'en',
            isPremium: false,
            createdAt: DateTime.now(),
          );
    } catch (e) {
      throw AppException(_getAuthError(e.toString()));
    }
  }

  Future<UserModel> signUpWithEmail(String name, String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      final userModel = UserModel(
        uid: response.user!.id,
        name: name,
        email: email,
        preferredLanguage: 'en',
        isPremium: false,
        createdAt: DateTime.now(),
      );
      await _supabase.from('users').upsert(userModel.toMap());
      return userModel;
    } catch (e) {
      throw AppException(_getAuthError(e.toString()));
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw const AppException('Google sign in cancelled');
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw const AppException('Google sign in failed: no ID token');
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
      return await getCurrentUser() ??
          UserModel(
            uid: response.user!.id,
            name: response.user!.userMetadata?['name'] ?? 'User',
            email: response.user!.email ?? '',
            photoUrl: response.user!.userMetadata?['avatar_url'],
            preferredLanguage: 'en',
            isPremium: false,
            createdAt: DateTime.now(),
          );
    } catch (e) {
      throw AppException(_getAuthError(e.toString()));
    }
  }

  Future<UserModel> signInAsGuest() async {
    try {
      final response = await _supabase.auth.signInAnonymously();
      final userModel = UserModel(
        uid: response.user!.id,
        name: 'Guest',
        email: '',
        preferredLanguage: 'en',
        isPremium: false,
        createdAt: DateTime.now(),
      );
      try {
        await _supabase.from('users').upsert(userModel.toMap());
      } catch (_) {}
      return userModel;
    } catch (e) {
      throw AppException(_getAuthError(e.toString()));
    }
  }

  Future<void> updateUserName(String uid, String name) async {
    await _supabase.from('users').update({'name': name}).eq('uid', uid);
  }

  Future<void> signOut() async {
    try { await _googleSignIn.signOut(); } catch (_) {}
    await _supabase.auth.signOut();
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw AppException(_getAuthError(e.toString()));
    }
  }

  String _getAuthError(String message) {
    if (message.contains('Invalid login')) return 'Invalid email or password';
    if (message.contains('Email already')) return 'Email already registered';
    if (message.contains('weak')) return 'Password is too weak';
    if (message.contains('network')) return 'No internet connection';
    return 'Authentication failed. Please try again';
  }
}



