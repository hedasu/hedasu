import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../../../core/services/storage_service.dart';

final AuthController authController = AuthController();

class AuthController extends ChangeNotifier {
  AuthController() {
    _initUser();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

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
      // Varsayılan giriş yapmış demo kullanıcı
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

  Future<bool> login(String email, String password) async {
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

  Future<void> logout() async {
    _currentUser = null;
    await StorageService.saveUserEmail('');
    notifyListeners();
  }
}
