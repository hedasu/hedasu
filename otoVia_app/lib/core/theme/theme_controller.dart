import 'package:flutter/material.dart';
import '../services/storage_service.dart';

final ThemeController themeController = ThemeController();

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.dark) {
    _loadTheme();
  }

  bool get isDarkMode => value == ThemeMode.dark;

  void _loadTheme() {
    final bool? savedIsDark = StorageService.getThemeMode();
    if (savedIsDark != null) {
      value = savedIsDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      value = ThemeMode.dark; // Varsayılan Obsidian Luxury
    }
  }

  Future<void> toggleTheme() async {
    final bool newIsDark = !isDarkMode;
    value = newIsDark ? ThemeMode.dark : ThemeMode.light;
    await StorageService.saveThemeMode(newIsDark);
  }

  Future<void> setTheme(ThemeMode mode) async {
    value = mode;
    await StorageService.saveThemeMode(mode == ThemeMode.dark);
  }
}
