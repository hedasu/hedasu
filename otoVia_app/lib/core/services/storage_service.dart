import 'package:shared_preferences/shared_preferences.dart';

/// Yerel Veri Depolama Servisi
///
/// [SharedPreferences] kütüphanesini kullanarak kullanıcı tercihleri,
/// tema modu, favori araç kimlikleri ve kullanıcı e-postası gibi verileri
/// cihaz hafızasında kalıcı olarak saklar ve yönetir.
class StorageService {
  // Saklama Anahtarları (Keys)
  static const String _keyThemeMode = 'otovia_theme_mode';
  static const String _keyFavorites = 'otovia_favorites';
  static const String _keyUserEmail = 'otovia_user_email';

  /// SharedPreferences tekil (singleton) örneği
  static SharedPreferences? _prefs;

  /// Servisin asenkron olarak ilklendirilmesini sağlar
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Seçilen tema modunu (karanlık / aydınlık) hafızaya kaydeder
  static Future<bool> saveThemeMode(bool isDark) async {
    await init();
    return await _prefs?.setBool(_keyThemeMode, isDark) ?? false;
  }

  /// Hafızada saklanan tema tercihini döner (kayıt yoksa null)
  static bool? getThemeMode() {
    return _prefs?.getBool(_keyThemeMode);
  }

  /// Kullanıcının favorilediği araç ID listesini kaydeder
  static Future<bool> saveFavorites(List<String> ids) async {
    await init();
    return await _prefs?.setStringList(_keyFavorites, ids) ?? false;
  }

  /// Hafızadaki favori araç ID listesini okur
  static List<String> getFavorites() {
    return _prefs?.getStringList(_keyFavorites) ?? [];
  }

  /// Giriş yapan kullanıcının e-posta adresini hatırlar
  static Future<bool> saveUserEmail(String email) async {
    await init();
    return await _prefs?.setString(_keyUserEmail, email) ?? false;
  }

  /// Hafızadaki kayıtlı e-posta adresini döner
  static String? getUserEmail() {
    return _prefs?.getString(_keyUserEmail);
  }
}
