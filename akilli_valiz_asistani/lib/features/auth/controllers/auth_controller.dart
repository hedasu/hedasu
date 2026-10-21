import 'package:flutter/foundation.dart';
import '../../../core/services/storage_service.dart';
import '../models/user_model.dart';

class AuthController {
  final StorageService _storageService;

  final ValueNotifier<bool> isLoginMode = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);
  final ValueNotifier<UserModel?> currentUser = ValueNotifier<UserModel?>(null);

  AuthController({required StorageService storageService})
      : _storageService = storageService {
    currentUser.value = _storageService.getUser();
  }

  void toggleMode() {
    isLoginMode.value = !isLoginMode.value;
    errorMessage.value = null;
  }

  Future<bool> authenticate({
    required String email,
    required String password,
    String? name,
  }) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      errorMessage.value = 'Lütfen geçerli bir e-posta adresi girin.';
      return false;
    }
    if (password.length < 6) {
      errorMessage.value = 'Şifre en az 6 karakter olmalıdır.';
      return false;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      // Clean authentication simulation
      await Future.delayed(const Duration(milliseconds: 600));
      final user = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name?.trim().isNotEmpty == true ? name!.trim() : 'Gezgin Pilot',
        email: email.trim(),
        isDarkMode: true,
      );

      await _storageService.saveUser(user);
      currentUser.value = user;
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = 'Giriş yapılamadı: $e';
      isLoading.value = false;
      return false;
    }
  }

  Future<void> continueAsGuest() async {
    final user = const UserModel(
      id: 'guest_user',
      name: 'Misafir Gezgin',
      email: 'misafir@packpilot.app',
      isDarkMode: true,
    );
    await _storageService.saveUser(user);
    currentUser.value = user;
  }

  void dispose() {
    isLoginMode.dispose();
    isLoading.dispose();
    errorMessage.dispose();
    currentUser.dispose();
  }
}
