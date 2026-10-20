import 'package:flutter/material.dart';
import '../models/opportunity_model.dart';

/// Fırsat Kartı (<40 satır build)
class OpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final VoidCallback onDetails;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(opp: opportunity, theme: theme, colorScheme: colorScheme),
            const SizedBox(height: 8),
            Text(
              opportunity.title,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Koşul: ${opportunity.eligibilityCriteria}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            _Footer(opp: opportunity, onDetails: onDetails),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final OpportunityModel opp;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _Header({required this.opp, required this.theme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            opp.organization,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        Text(
          opp.grantAmount,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final OpportunityModel opp;
  final VoidCallback onDetails;

  const _Footer({required this.opp, required this.onDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.timer_outlined, size: 14),
            const SizedBox(width: 4),
            Text('Son Başvuru: ${opp.deadline}', style: const TextStyle(fontSize: 11)),
          ],
        ),
        FilledButton.tonal(
          onPressed: onDetails,
          style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
          child: const Text('İncele'),
        ),
      ],
    );
  }
}
