import 'package:flutter/material.dart';
import '../controller/project_workspace_controller.dart';
import '../models/project_task_model.dart';
import '../widgets/task_item_card.dart';

class ProjectWorkspaceView extends StatelessWidget {
  final ProjectWorkspaceController controller;

  const ProjectWorkspaceView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proje Çalışma Alanı')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Yeni Görev'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<ProjectTaskModel>>(
          valueListenable: controller.tasks,
          builder: (context, tasks, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _WorkspaceProgress(controller: controller),
                const SizedBox(height: 16),
                ...tasks.map(
                  (task) => TaskItemCard(
                    task: task,
                    onToggle: () => controller.toggleTask(task.id),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni Görev Ekle'),
        content: TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(hintText: 'Görev tanımı...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                controller.addTask(titleCtrl.text.trim(), 'Can Demir', 'Gelecek Hafta');
                Navigator.pop(ctx);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceProgress extends StatelessWidget {
  final ProjectWorkspaceController controller;

  const _WorkspaceProgress({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = controller.progressRatio;
    final percent = (ratio * 100).toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kilometre Taşı İlerlemesi',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '%$percent',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: ratio, borderRadius: BorderRadius.circular(6)),
          ],
        ),
      ),
    );
  }
}
