import 'package:flutter/foundation.dart';
import '../../../core/services/theme_service.dart';

/// Ayarlar Kontrolcüsü
class SettingsController {
  final ValueNotifier<bool> pushNotificationsEnabled = ValueNotifier<bool>(true);
  final ValueNotifier<bool> emailRemindersEnabled = ValueNotifier<bool>(true);

  void toggleTheme() {
    ThemeService.instance.toggleTheme();
  }

  void togglePush(bool val) {
    pushNotificationsEnabled.value = val;
  }

  void toggleEmail(bool val) {
    emailRemindersEnabled.value = val;
  }

  void dispose() {
    pushNotificationsEnabled.dispose();
    emailRemindersEnabled.dispose();
  }
}
