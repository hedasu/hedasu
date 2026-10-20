import 'package:flutter/material.dart';

/// Başvuru Durum Sabitleri
enum ApplicationStatus {
  submitted('Gönderildi', Colors.blue),
  reviewing('İnceleniyor', Colors.orange),
  accepted('Kabul Edildi', Colors.green),
  rejected('Reddedildi', Colors.red);

  final String label;
  final Color color;
  const ApplicationStatus(this.label, this.color);
}

/// Ekip Üyeliği Başvuru Modeli
class ApplicationModel {
  final String id;
  final String startupName;
  final String roleApplied;
  final DateTime appliedAt;
  final ApplicationStatus status;
  final String note;

  const ApplicationModel({
    required this.id,
    required this.startupName,
    required this.roleApplied,
    required this.appliedAt,
    required this.status,
    required this.note,
  });

  static List<ApplicationModel> get samples => [
        ApplicationModel(
          id: 'app_1',
          startupName: 'HealthPulse AI',
          roleApplied: 'Kurucu Ortak & Mobil Geliştirici',
          appliedAt: DateTime.now().subtract(const Duration(days: 2)),
          status: ApplicationStatus.reviewing,
          note: 'Portfolyo ve GitHub profiliniz ekip lideri tarafından inceleniyor.',
        ),
        ApplicationModel(
          id: 'app_2',
          startupName: 'EcoTrack Carbon',
          roleApplied: 'Büyüme & Pazarlama Lideri',
          appliedAt: DateTime.now().subtract(const Duration(days: 7)),
          status: ApplicationStatus.accepted,
          note: 'Tebrikler! İlk tanışma toplantısı için davet bağlantısı oluşturuldu.',
        ),
        ApplicationModel(
          id: 'app_3',
          startupName: 'RoboLogist',
          roleApplied: 'Backend Mimarı',
          appliedAt: DateTime.now().subtract(const Duration(days: 14)),
          status: ApplicationStatus.submitted,
          note: 'Başvurunuz kurucu ekibe başarıyla iletildi.',
        ),
      ];
}
