import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/models/user_model.dart';

class ProfileController {
  final StorageService _storageService;

  final ValueNotifier<UserModel> user = ValueNotifier<UserModel>(
    const UserModel(id: 'temp', name: '', email: ''),
  );

  ProfileController({required StorageService storageService})
      : _storageService = storageService {
    loadUser();
  }

  void loadUser() {
    user.value = _storageService.getUser();
  }

  Future<void> setThemePreference(String theme) async {
    final updated = user.value.copyWith(themePreference: theme);
    await _storageService.saveUser(updated);
    user.value = updated;
  }

  Future<void> toggleDarkMode(bool isDark) async {
    final theme = isDark ? 'dark' : 'light';
    await setThemePreference(theme);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final updated = user.value.copyWith(notificationsEnabled: enabled);
    await _storageService.saveUser(updated);
    user.value = updated;
  }

  Future<void> deleteAccount() async {
    // Reset user to blank guest
    final guest = const UserModel(
      id: 'guest_user',
      name: 'Misafir Gezgin',
      email: 'misafir@packpilot.app',
      themePreference: 'light',
      notificationsEnabled: true,
      cycleTrackingEnabled: false,
    );
    await _storageService.saveUser(guest);
    user.value = guest;
  }

  void dispose() {
    user.dispose();
  }
}
