import 'package:flutter/foundation.dart';
import '../models/onboarding_role_model.dart';

/// Onboarding ve Rol Seçim Kontrolcüsü
class OnboardingController {
  final ValueNotifier<String?> selectedRoleId = ValueNotifier<String?>('idea');
  final List<OnboardingRoleModel> roles = OnboardingRoleModel.defaultRoles;

  void selectRole(String id) {
    selectedRoleId.value = id;
  }

  void dispose() {
    selectedRoleId.dispose();
  }
}
