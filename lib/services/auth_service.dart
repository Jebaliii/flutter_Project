import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/app_user.dart';
import 'app_exception.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Web client ID (Firebase Console > Authentication > Google > Web SDK configuration)
  static const _webClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

  static bool _googleInitialized = false;

  User? get currentUser => _auth.currentUser;

  /// Google Sign-In n'est disponible que sur Android (et iOS).
  bool get googleSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  // ---------- Email / mot de passe ----------
  // Lancent une [AppException] (message traduit par `localizeError`).

  Future<User?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code}');
      throw AppException.fromFirebaseCode(e.code);
    }
  }

  /// [adminCode] non null => registration as an administrator.
  Future<User?> register(
    String email,
    String password, {
    String? adminCode,
  }) async {
    if (adminCode != null && adminCode != UserService.adminCode) {
      throw const AppException(AppErrorCode.adminCodeInvalid);
    }
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        await UserService().ensureProfile(
          user,
          role: adminCode != null ? 'admin' : 'user',
        );
      }
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Register error: ${e.code}');
      throw AppException.fromFirebaseCode(e.code);
    }
  }

  // ---------- Profil (rôle) ----------

  /// Profile of the signed-in user (created if missing). Signs out and
  /// throws if an administrator blocked the account.
  Future<AppUser> loadProfile(User user) async {
    final profile = await UserService().ensureProfile(user);
    if (profile.disabled) {
      await logout();
      throw const AppException(AppErrorCode.accountDisabled);
    }
    return profile;
  }

  // ---------- Google ----------

  /// Retourne l'utilisateur, ou null si l'utilisateur a annulé.
  /// Lance une [AppException] en cas d'erreur.
  Future<User?> signInWithGoogle() async {
    if (!googleSupported) {
      throw const AppException(AppErrorCode.googleUnsupported);
    }

    try {
      final google = GoogleSignIn.instance;

      if (!_googleInitialized) {
        await google.initialize(serverClientId: _webClientId);
        _googleInitialized = true;
      }

      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AppException(AppErrorCode.googleTokenMissing);
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } on GoogleSignInException catch (e) {
      debugPrint('Google error: ${e.code} ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      throw AppException(AppErrorCode.googleFailed, e.code.name);
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Google error: ${e.code}');
      throw AppException.fromFirebaseCode(e.code);
    }
  }

  // ---------- Déconnexion ----------

  Future<void> logout() async {
    if (googleSupported && _googleInitialized) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        debugPrint('Google signOut error: $e');
      }
    }
    await _auth.signOut();
  }
}
