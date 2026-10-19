import 'package:flutter/material.dart';

/// Tema Durum Kontrolcüsü (ValueNotifier Tabanlı - Clean State)
class ThemeController {
  final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  /// Koyu ve Açık mod arasında geçiş yapar
  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  /// Belirli bir tema modunu ayarlar
  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }

  void dispose() {
    themeMode.dispose();
  }
}
