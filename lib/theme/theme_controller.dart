import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the light / dark choice and persists it.
/// Until the user picks one, the app follows the device setting.
class ThemeController extends ChangeNotifier {
  static const _prefsKey = 'app_theme_mode';

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  ThemeController([this._mode = ThemeMode.system]);

  static Future<ThemeController> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_prefsKey);
      final mode = ThemeMode.values.where((m) => m.name == name).firstOrNull;
      if (mode != null) return ThemeController(mode);
    } catch (e) {
      debugPrint('ThemeController load error: $e');
    }
    return ThemeController();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, mode.name);
    } catch (e) {
      debugPrint('ThemeController save error: $e');
    }
  }

  /// Switches to the opposite of what is currently displayed.
  Future<void> toggle(Brightness current) =>
      setMode(current == Brightness.dark ? ThemeMode.light : ThemeMode.dark);
}
