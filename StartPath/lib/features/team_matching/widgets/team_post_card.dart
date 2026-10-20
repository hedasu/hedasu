import 'package:flutter/material.dart';
import '../models/team_post_model.dart';

/// Ekip İlanı Kartı (<40 satır build)
class TeamPostCard extends StatelessWidget {
  final TeamPostModel post;
  final VoidCallback onApply;

  const TeamPostCard({
    super.key,
    required this.post,
    required this.onApply,
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
            _CardHeader(post: post, theme: theme, colorScheme: colorScheme),
            const SizedBox(height: 8),
            Text(
              post.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _SkillsWrap(skills: post.requiredSkills),
            const SizedBox(height: 14),
            _BottomRow(post: post, onApply: onApply),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final TeamPostModel post;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _CardHeader({required this.post, required this.theme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.roleNeeded,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                '${post.startupName} • ${post.sector}',
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.primary),
              ),
            ],
          ),
        ),
        _CompatibilityBadge(score: post.compatibilityScore),
      ],
    );
  }
}

class _CompatibilityBadge extends StatelessWidget {
  final int score;

  const _CompatibilityBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '%$score Uyumlu',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

class _SkillsWrap extends StatelessWidget {
  final List<String> skills;

  const _SkillsWrap({required this.skills});

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

class _BottomRow extends StatelessWidget {
  final TeamPostModel post;
  final VoidCallback onApply;

  const _BottomRow({required this.post, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 16),
            const SizedBox(width: 4),
            Text(post.workType, style: const TextStyle(fontSize: 12)),
          ],
        ),
        FilledButton.tonal(
          onPressed: onApply,
          child: const Text('Başvur'),
        ),
      ],
    );
  }
}
