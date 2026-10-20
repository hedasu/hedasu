import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Global tema kontrolcü nesnesi (Singleton erişim modeli)
final ThemeController themeController = ThemeController();

/// Uygulama Tema Kontrolcüsü
///
/// [ValueNotifier] ile reaktif olarak [ThemeMode] durumunu yönetir.
/// Kullanıcının tema tercihini hafızada (SharedPreferences) saklar ve
/// uygulama açıldığında son seçilen modu geri yükler.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.dark) {
    _loadTheme();
  }

  /// Mevcut temanın koyu modda olup olmadığını bildirir
  bool get isDarkMode => value == ThemeMode.dark;

  /// Hafızaya kaydedilmiş tema tercihini okur ve durumu günceller
  void _loadTheme() {
    final bool? savedIsDark = StorageService.getThemeMode();
    if (savedIsDark != null) {
      value = savedIsDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      // Varsayılan tema: Obsidian Luxury (Koyu Tema)
      value = ThemeMode.dark;
    }
  }

  /// Koyu ve açık tema arasında geçiş yapar ve tercihi kaydeder
  Future<void> toggleTheme() async {
    final bool newIsDark = !isDarkMode;
    value = newIsDark ? ThemeMode.dark : ThemeMode.light;
    await StorageService.saveThemeMode(newIsDark);
  }

  /// Belirli bir [ThemeMode] değerini atar ve kaydeder
  Future<void> setTheme(ThemeMode mode) async {
    value = mode;
    await StorageService.saveThemeMode(mode == ThemeMode.dark);
  }
}
