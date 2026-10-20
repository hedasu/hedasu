import 'package:flutter_test/flutter_test.dart';
import 'package:startpath/features/mentor_matching/controller/mentor_matching_controller.dart';

void main() {
  group('MentorMatchingController Birim Testleri', () {
    late MentorMatchingController controller;

    setUp(() {
      controller = MentorMatchingController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta mentor listesi dolu ve yükleme kapalı olmalıdır', () {
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isNull);
      expect(controller.mentors.value.isNotEmpty, true);
      expect(controller.selectedSector.value, 'Tümü');
    });

    test('Sektöre göre filtreleme doğru çalışmalıdır', () {
      controller.filterSector('Fintech');
      expect(controller.selectedSector.value, 'Fintech');
      expect(controller.filteredMentors.every((m) => m.sector.toLowerCase() == 'fintech'), true);
    });

    test('reload çağrıldığında liste başarıyla yenilenmelidir', () async {
      await controller.reload();
      expect(controller.isLoading.value, false);
      expect(controller.mentors.value.isNotEmpty, true);
    });
  });
}
