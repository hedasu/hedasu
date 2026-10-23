import 'dart:io';

class ThemeStorage {
  static File get _file => File('.habipet_theme.cfg');

  static void saveTheme(bool isDark) {
    try {
      _file.writeAsStringSync(isDark ? 'dark' : 'light');
    } catch (_) {}
  }

  static bool? loadTheme() {
    try {
      if (_file.existsSync()) {
        final content = _file.readAsStringSync().trim();
        return content == 'dark';
      }
    } catch (_) {}
    return null;
  }
}
