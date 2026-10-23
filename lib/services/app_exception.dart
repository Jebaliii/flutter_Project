/// Error raised by the services. The UI turns [code] into a translated
/// message (see `localizeError` in `l10n/l10n.dart`).
enum AppErrorCode {
  googleUnsupported,
  googleTokenMissing,
  googleFailed,
  firebase,
  notLoggedIn,
  firestoreTimeout,
  invalidCredentials,
  emailInUse,
  weakPassword,
  invalidEmail,
  network,
  tooManyRequests,
  permissionDenied,
  accountDisabled,
  adminCodeInvalid,
}

class AppException implements Exception {
  final AppErrorCode code;
  final String? detail;

  const AppException(this.code, [this.detail]);

  /// Maps a Firebase (Auth / Firestore) error code to an [AppException].
  factory AppException.fromFirebaseCode(String code) => switch (code) {
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' ||
    'user-disabled' => const AppException(AppErrorCode.invalidCredentials),
    'email-already-in-use' => const AppException(AppErrorCode.emailInUse),
    'weak-password' => const AppException(AppErrorCode.weakPassword),
    'invalid-email' => const AppException(AppErrorCode.invalidEmail),
    'network-request-failed' ||
    'unavailable' => const AppException(AppErrorCode.network),
    'too-many-requests' => const AppException(AppErrorCode.tooManyRequests),
    'permission-denied' ||
    'unauthenticated' => const AppException(AppErrorCode.permissionDenied),
    'deadline-exceeded' => const AppException(AppErrorCode.firestoreTimeout),
    _ => AppException(AppErrorCode.firebase, code),
  };

  @override
  String toString() =>
      'AppException(${code.name}${detail == null ? '' : ', $detail'})';
}
