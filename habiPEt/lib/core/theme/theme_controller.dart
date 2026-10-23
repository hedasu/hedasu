import 'package:flutter/material.dart';
import 'theme_storage.dart';

class ThemeController extends ChangeNotifier {
  late ThemeMode _themeMode;

  ThemeController() {
    final savedIsDark = ThemeStorage.loadTheme();
    _themeMode = (savedIsDark ?? true) ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    ThemeStorage.saveTheme(isDarkMode);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    ThemeStorage.saveTheme(isDarkMode);
    notifyListeners();
  }
}
