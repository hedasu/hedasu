import 'package:flutter/foundation.dart';
import '../models/application_model.dart';

/// Başvuru Takip Kontrolcüsü
class ApplicationsController {
  final ValueNotifier<List<ApplicationModel>> applications =
      ValueNotifier<List<ApplicationModel>>(ApplicationModel.samples);

  void submitApplication({
    required String startupName,
    required String roleApplied,
  }) {
    final newApp = ApplicationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startupName: startupName,
      roleApplied: roleApplied,
      appliedAt: DateTime.now(),
      status: ApplicationStatus.submitted,
      note: 'Yeni başvurunuz kurucu ekibe iletildi.',
    );
    applications.value = [newApp, ...applications.value];
  }

  void dispose() {
    applications.dispose();
  }
}
