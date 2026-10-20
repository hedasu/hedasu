import 'package:flutter/material.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../models/application_model.dart';

/// Başvuru Kartı (<40 satır build)
class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationCard({super.key, required this.application});

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
            _HeaderRow(app: application, theme: theme),
            const SizedBox(height: 8),
            Text(
              application.roleApplied,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              application.note,
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final ApplicationModel app;
  final ThemeData theme;

  const _HeaderRow({required this.app, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            app.startupName,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        AppStatusBadge(
          label: app.status.label,
          color: app.status.color,
        ),
      ],
    );
  }
}
