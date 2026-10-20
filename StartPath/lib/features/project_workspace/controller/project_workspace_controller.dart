import 'package:flutter/foundation.dart';
import '../models/project_task_model.dart';

/// Çalışma Alanı Görev ve Hedef Kontrolcüsü
class ProjectWorkspaceController {
  final ValueNotifier<List<ProjectTaskModel>> tasks =
      ValueNotifier<List<ProjectTaskModel>>(ProjectTaskModel.samples);

  int get completedTasksCount => tasks.value.where((t) => t.isDone).length;
  double get progressRatio =>
      tasks.value.isEmpty ? 0.0 : completedTasksCount / tasks.value.length;

  void toggleTask(String id) {
    tasks.value = tasks.value.map((t) {
      if (t.id == id) {
        return t.copyWith(isDone: !t.isDone);
      }
      return t;
    }).toList();
  }

  void addTask(String title, String assignee, String dueDate) {
    final newTask = ProjectTaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      assignee: assignee,
      dueDate: dueDate,
      isDone: false,
      priority: 'Normal',
    );
    tasks.value = [...tasks.value, newTask];
  }

  void dispose() {
    tasks.dispose();
  }
}
