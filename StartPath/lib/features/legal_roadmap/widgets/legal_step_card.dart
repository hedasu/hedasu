import 'package:flutter/material.dart';
import '../models/legal_step_model.dart';

/// Hukuki Adım Kartı (<40 satır build)
class LegalStepCard extends StatelessWidget {
  final LegalStepModel step;
  final VoidCallback onToggle;

  const LegalStepCard({
    super.key,
    required this.step,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepHeader(step: step, onToggle: onToggle, theme: theme),
            const SizedBox(height: 8),
            Text(
              step.summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _RequiredDocs(docs: step.requiredDocuments),
          ],
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final LegalStepModel step;
  final VoidCallback onToggle;
  final ThemeData theme;

  const _StepHeader({required this.step, required this.onToggle, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: step.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adım ${step.stepOrder} • ${step.category}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                step.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: step.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RequiredDocs extends StatelessWidget {
  final List<String> docs;

  const _RequiredDocs({required this.docs});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: docs.map((d) {
        return Chip(
          avatar: const Icon(Icons.attach_file_rounded, size: 14),
          label: Text(d, style: const TextStyle(fontSize: 11)),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}
