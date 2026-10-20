import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyThemeMode = 'otovia_theme_mode';
  static const String _keyFavorites = 'otovia_favorites';
  static const String _keyUserEmail = 'otovia_user_email';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> saveThemeMode(bool isDark) async {
    await init();
    return await _prefs?.setBool(_keyThemeMode, isDark) ?? false;
  }

  static bool? getThemeMode() {
    return _prefs?.getBool(_keyThemeMode);
  }

  static Future<bool> saveFavorites(List<String> ids) async {
    await init();
    return await _prefs?.setStringList(_keyFavorites, ids) ?? false;
  }

  static List<String> getFavorites() {
    return _prefs?.getStringList(_keyFavorites) ?? [];
  }

  static Future<bool> saveUserEmail(String email) async {
    await init();
    return await _prefs?.setString(_keyUserEmail, email) ?? false;
  }

  static String? getUserEmail() {
    return _prefs?.getString(_keyUserEmail);
  }
}
