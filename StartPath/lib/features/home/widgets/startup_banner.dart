import 'package:flutter/material.dart';
import '../models/home_dashboard_model.dart';

/// Girişim Durum Özeti Banner'ı (<40 satır build)
class StartupBanner extends StatelessWidget {
  final HomeDashboardModel dashboard;
  final VoidCallback onTap;

  const StartupBanner({
    super.key,
    required this.dashboard,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.8),
            colorScheme.surfaceContainerHighest,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dashboard.activeStartupName,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              _ProgressBadge(progress: dashboard.roadmapProgressPercent),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            dashboard.stage,
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: dashboard.roadmapProgressPercent / 100,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: colorScheme.surface,
          ),
        ],
      ),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  final int progress;

  const _ProgressBadge({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Yol Haritası: %$progress',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
