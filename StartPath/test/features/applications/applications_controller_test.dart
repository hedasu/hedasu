import 'package:flutter_test/flutter_test.dart';
import 'package:startpath/features/applications/controller/applications_controller.dart';
import 'package:startpath/features/applications/models/application_model.dart';

void main() {
  group('ApplicationsController Birim Testleri', () {
    late ApplicationsController controller;

    setUp(() {
      controller = ApplicationsController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta örnek başvurular yüklenmelidir', () {
      expect(controller.applications.value.isNotEmpty, true);
    });

    test('submitApplication yeni bir başvuru eklemelidir', () {
      final initialCount = controller.applications.value.length;
      controller.submitApplication(
        startupName: 'Yeni Girişim',
        roleApplied: 'Kurucu Ortak',
      );

      expect(controller.applications.value.length, initialCount + 1);
      expect(controller.applications.value.first.startupName, 'Yeni Girişim');
      expect(controller.applications.value.first.status, ApplicationStatus.submitted);
    });
  });
}
