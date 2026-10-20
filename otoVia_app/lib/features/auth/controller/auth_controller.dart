import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../../../core/services/storage_service.dart';

/// Kimlik doğrulama ve kullanıcı oturumu kontrolcüsü (Singleton)
final AuthController authController = AuthController();

/// Kullanıcı Kimlik Doğrulama ve Profil Kontrolcüsü
///
/// Giriş yapma (Login), kayıt olma (Register), profil güncelleme
/// ve oturum kapatma (Logout) işlemlerini [ChangeNotifier] yapısıyla yönetir.
class AuthController extends ChangeNotifier {
  AuthController() {
    _initUser();
  }

  /// Aktif oturum açmış kullanıcı modeli (oturum yoksa null)
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  /// Kullanıcının giriş yapıp yapmadığını belirtir
  bool get isAuthenticated => _currentUser != null;

  /// Saklanan kullanıcı bilgilerini yükler veya demo bir profil oluşturur
  void _initUser() {
    final String? email = StorageService.getUserEmail();
    if (email != null && email.isNotEmpty) {
      _currentUser = UserModel(
        id: 'usr_001',
        name: 'Deniz',
        surname: 'Yılmaz',
        phone: '+90 532 555 0199',
        email: email,
        driverLicenseClass: 'B',
        isVerified: true,
      );
    } else {
      // Başlangıç için hazır demo kullanıcı
      _currentUser = const UserModel(
        id: 'usr_001',
        name: 'Deniz',
        surname: 'Yılmaz',
        phone: '+90 532 555 0199',
        email: 'deniz.yilmaz@otovia.com',
        driverLicenseClass: 'B',
        isVerified: true,
      );
    }
  }

  /// E-posta ve şifre ile sisteme giriş yapar
  Future<bool> login(String email, String password) async {
    // Gerçekçi ağ gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Deniz',
      surname: 'Yılmaz',
      phone: '+90 532 555 0199',
      email: email,
      driverLicenseClass: 'B',
      isVerified: true,
    );
    await StorageService.saveUserEmail(email);
    notifyListeners();
    return true;
  }

  /// Yeni kullanıcı kaydı oluşturur
  Future<bool> register({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      surname: surname,
      phone: phone,
      email: email,
      driverLicenseClass: 'B',
      isVerified: true,
    );
    await StorageService.saveUserEmail(email);
    notifyListeners();
    return true;
  }

  /// Kullanıcının profil bilgilerini (ad, soyad, telefon, ehliyet sınıfı) günceller
  Future<void> updateProfile({
    required String name,
    required String surname,
    required String phone,
    required String licenseClass,
  }) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      surname: surname,
      phone: phone,
      driverLicenseClass: licenseClass,
    );
    notifyListeners();
  }

  /// Kullanıcı oturumunu kapatır ve yerel hafızadaki oturum bilgisini temizler
  Future<void> logout() async {
    _currentUser = null;
    await StorageService.saveUserEmail('');
    notifyListeners();
  }
}
