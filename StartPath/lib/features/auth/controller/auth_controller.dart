import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Kimlik Doğrulama ve Oturum Kontrolcüsü
class AuthController {
  final ValueNotifier<UserModel?> currentUser =
      ValueNotifier<UserModel?>(UserModel.initialDemo());
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  bool get isAuthenticated => currentUser.value != null;

  void addRole(String role) {
    final user = currentUser.value;
    if (user == null || user.roles.contains(role)) return;
    currentUser.value = user.copyWith(
      roles: [...user.roles, role],
      profileCompleteness: (user.profileCompleteness + 10).clamp(0, 100),
    );
  }

  void logout() {
    currentUser.value = null;
  }

  void loginAsDemo() {
    currentUser.value = UserModel.initialDemo();
  }

  void dispose() {
    currentUser.dispose();
    isLoading.dispose();
  }
}
