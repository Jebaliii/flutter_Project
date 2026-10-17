/// Error raised by the services. The UI turns [code] into a translated
/// message (see `localizeError` in `l10n/l10n.dart`).
enum AppErrorCode {
  googleUnsupported,
  googleTokenMissing,
  googleFailed,
  firebase,
  notLoggedIn,
  firestoreTimeout,
}

class AppException implements Exception {
  final AppErrorCode code;
  final String? detail;

  const AppException(this.code, [this.detail]);

  @override
  String toString() => 'AppException(${code.name}${detail == null ? '' : ', $detail'})';
}
