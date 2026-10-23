// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

class ThemeStorage {
  static void saveTheme(bool isDark) {
    try {
      html.window.localStorage['habipet_theme_dark'] = isDark ? 'true' : 'false';
    } catch (_) {}
  }

  static bool? loadTheme() {
    try {
      final value = html.window.localStorage['habipet_theme_dark'];
      if (value != null) {
        return value == 'true';
      }
    } catch (_) {}
    return null;
  }
}
