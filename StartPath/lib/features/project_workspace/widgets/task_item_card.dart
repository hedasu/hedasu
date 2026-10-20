import 'package:flutter/material.dart';
import '../models/project_task_model.dart';

/// Görev Kartı (<40 satır build)
class TaskItemCard extends StatelessWidget {
  final ProjectTaskModel task;
  final VoidCallback onToggle;

  const TaskItemCard({
    super.key,
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Checkbox(
              value: task.isDone,
              onChanged: (_) => onToggle(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: task.isDone ? TextDecoration.lineThrough : null,
                      color: task.isDone ? colorScheme.onSurfaceVariant : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task.assignee} • Son Tarih: ${task.dueDate}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
