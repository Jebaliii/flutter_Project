import 'package:flutter/widgets.dart';

import '../services/app_exception.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Translated message for an error thrown by a service.
String localizeError(AppLocalizations l, Object error) {
  if (error is AppException) {
    final detail = error.detail ?? '';
    return switch (error.code) {
      AppErrorCode.googleUnsupported => l.errorGoogleUnsupported,
      AppErrorCode.googleTokenMissing => l.errorGoogleToken,
      AppErrorCode.googleFailed => l.errorGoogleFailed(detail),
      AppErrorCode.firebase => l.errorFirebase(detail),
      AppErrorCode.notLoggedIn => l.errorNotLoggedIn,
      AppErrorCode.firestoreTimeout => l.errorFirestoreTimeout,
    };
  }
  return error.toString().replaceFirst('Exception: ', '');
}
