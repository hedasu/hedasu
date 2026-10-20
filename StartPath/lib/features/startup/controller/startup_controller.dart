import 'package:flutter/foundation.dart';
import '../models/startup_model.dart';

/// Girişim Formu ve Yönetim Kontrolcüsü
class StartupController {
  final ValueNotifier<StartupModel> startup =
      ValueNotifier<StartupModel>(StartupModel.sample());
  final ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);
  final ValueNotifier<String?> successMessage = ValueNotifier<String?>(null);

  void updateStartup(StartupModel updated) {
    startup.value = updated;
  }

  Future<void> save() async {
    isSaving.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      successMessage.value = 'Girişim bilgileri başarıyla güncellendi!';
    } finally {
      isSaving.value = false;
    }
  }

  void clearMessage() {
    successMessage.value = null;
  }

  void dispose() {
    startup.dispose();
    isSaving.dispose();
    successMessage.dispose();
  }
}
