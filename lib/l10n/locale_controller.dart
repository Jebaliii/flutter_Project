import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

/// Holds the language chosen in the app and persists it.
/// `locale == null` means "follow the device language".
class LocaleController extends ChangeNotifier {
  static const _prefsKey = 'app_locale';
  static const fallback = Locale('fr');

  Locale? _locale;
  Locale? get locale => _locale;

  LocaleController([this._locale]);

  static Future<LocaleController> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefsKey);
      if (code != null && _isSupported(code)) {
        return LocaleController(Locale(code));
      }
    } catch (e) {
      debugPrint('LocaleController load error: $e');
    }
    return LocaleController();
  }

  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale.languageCode) || locale == _locale) return;
    _locale = locale;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, locale.languageCode);
    } catch (e) {
      debugPrint('LocaleController save error: $e');
    }
  }

  /// Picks the device language when supported, French otherwise.
  static Locale resolve(Locale? device, Iterable<Locale> supported) {
    for (final l in supported) {
      if (l.languageCode == device?.languageCode) return l;
    }
    return fallback;
  }

  static bool _isSupported(String code) => AppLocalizations.supportedLocales
      .any((l) => l.languageCode == code);
}
