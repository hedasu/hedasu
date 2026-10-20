import 'package:flutter/material.dart';
import '../models/mentor_profile_model.dart';

/// Mentor Profil Kartı (<40 satır build)
class MentorCard extends StatelessWidget {
  final MentorProfileModel mentor;
  final VoidCallback onBookSession;

  const MentorCard({
    super.key,
    required this.mentor,
    required this.onBookSession,
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
            _Header(mentor: mentor, theme: theme, colorScheme: colorScheme),
            const SizedBox(height: 6),
            Text(
              mentor.title,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              mentor.about,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            _ExpertiseWrap(skills: mentor.expertise),
            const SizedBox(height: 14),
            _Actions(onBookSession: onBookSession),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final MentorProfileModel mentor;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _Header({required this.mentor, required this.theme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                mentor.fullName,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (mentor.isVerified) ...[
                const SizedBox(width: 6),
                Icon(Icons.verified_rounded, size: 18, color: colorScheme.primary),
              ],
            ],
          ),
        ),
        Icon(Icons.star_rounded, size: 18, color: colorScheme.tertiary),
        const SizedBox(width: 4),
        Text(
          mentor.rating.toStringAsFixed(2),
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ExpertiseWrap extends StatelessWidget {
  final List<String> skills;

  const _ExpertiseWrap({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: skills.map((s) {
        return Chip(
          label: Text(s, style: const TextStyle(fontSize: 11)),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}

class _Actions extends StatelessWidget {
  final VoidCallback onBookSession;

  const _Actions({required this.onBookSession});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: onBookSession,
        child: const Text('Görüşme Talebi Gönder'),
      ),
    );
  }
}
