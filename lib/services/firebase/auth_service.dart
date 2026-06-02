import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../core/errors/app_exception.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user get karo
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _getUserFromFirestore(user.uid);
  }

  // Email/Password Sign In
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _getUserFromFirestore(credential.user!.uid) ??
          _userFromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthError(e.code));
    }
  }

  // Email/Password Register
  Future<UserModel> signUpWithEmail(
      String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      final userModel = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        preferredLanguage: 'en',
        isPremium: false,
        createdAt: DateTime.now(),
      );
      await _saveUserToFirestore(userModel);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthError(e.code));
    }
  }

  // Google Sign In
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw const AuthException('Google sign in cancelled');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Check if user already exists
      final existing = await _getUserFromFirestore(user.uid);
      if (existing != null) return existing;

      // New user — save to Firestore
      final userModel = UserModel(
        uid: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        preferredLanguage: 'en',
        isPremium: false,
        createdAt: DateTime.now(),
      );
      await _saveUserToFirestore(userModel);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthError(e.code));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  // Apple Sign In (iOS only)
  Future<UserModel> signInWithApple() async {
    throw const AuthException('Apple sign in — coming soon');
  }

  // Guest Sign In
  Future<UserModel> signInAsGuest() async {
    try {
      final credential = await _auth.signInAnonymously();
      final userModel = UserModel(
        uid: credential.user!.uid,
        name: 'Guest',
        email: '',
        preferredLanguage: 'en',
        isPremium: false,
        createdAt: DateTime.now(),
      );
      await _saveUserToFirestore(userModel);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthError(e.code));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Password Reset
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthError(e.code));
    }
  }

  // ─── Private Helpers ───────────────────────────────────────

  Future<UserModel?> _getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  UserModel _userFromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? 'User',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      preferredLanguage: 'en',
      isPremium: false,
      createdAt: DateTime.now(),
    );
  }

  String _getAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'network-request-failed':
        return 'No internet connection';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}