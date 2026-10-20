import 'package:flutter_test/flutter_test.dart';
import 'package:startpath/features/project_workspace/controller/project_workspace_controller.dart';

void main() {
  group('ProjectWorkspaceController Birim Testleri', () {
    late ProjectWorkspaceController controller;

    setUp(() {
      controller = ProjectWorkspaceController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta görevler yüklenmeli ve ilerleme oranı hesaplanmalıdır', () {
      expect(controller.tasks.value.isNotEmpty, true);
      expect(controller.progressRatio, inInclusiveRange(0.0, 1.0));
    });

    test('addTask yeni görev eklemelidir', () {
      final initialLength = controller.tasks.value.length;
      controller.addTask('Yeni Birim Testi', 'Can', 'Yarın');
      expect(controller.tasks.value.length, initialLength + 1);
      expect(controller.tasks.value.last.title, 'Yeni Birim Testi');
    });

    test('toggleTask görev durumunu tersine çevirmelidir', () {
      final task = controller.tasks.value.first;
      final prevDone = task.isDone;
      controller.toggleTask(task.id);
      expect(controller.tasks.value.first.isDone, !prevDone);
    });
  });
}
