import 'package:flutter_test/flutter_test.dart';
import 'package:startpath/features/legal_roadmap/controller/legal_roadmap_controller.dart';

void main() {
  group('LegalRoadmapController Birim Testleri', () {
    late LegalRoadmapController controller;

    setUp(() {
      controller = LegalRoadmapController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç adımları ve ilerleme oranı hesaplanmalıdır', () {
      expect(controller.steps.value.isNotEmpty, true);
      expect(controller.completedCount, greaterThanOrEqualTo(0));
      expect(controller.progressPercentage, inInclusiveRange(0.0, 1.0));
    });

    test('toggleStep adımı tamamlandı/tamamlanmadı olarak değiştirmelidir', () {
      final firstStep = controller.steps.value.first;
      final initialStatus = firstStep.isCompleted;

      controller.toggleStep(firstStep.id);
      expect(controller.steps.value.first.isCompleted, !initialStatus);

      controller.toggleStep(firstStep.id);
      expect(controller.steps.value.first.isCompleted, initialStatus);
    });
  });
}
