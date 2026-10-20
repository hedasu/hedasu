import 'package:flutter/material.dart';
import '../models/profile_details_model.dart';

/// Profil Başlık ve Doluluk Kartı (<40 satır build)
class ProfileHeaderCard extends StatelessWidget {
  final ProfileDetailsModel profile;

  const ProfileHeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _AvatarInfo(profile: profile, theme: theme, colorScheme: colorScheme),
            const SizedBox(height: 14),
            _RolesWrap(roles: profile.activeRoles),
            const SizedBox(height: 16),
            _CompletenessBar(percent: profile.completenessPercent, colorScheme: colorScheme),
          ],
        ),
      ),
    );
  }
}

class _AvatarInfo extends StatelessWidget {
  final ProfileDetailsModel profile;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _AvatarInfo({required this.profile, required this.theme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            profile.fullName.substring(0, 2).toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary, fontSize: 18),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.fullName,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                profile.title,
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RolesWrap extends StatelessWidget {
  final List<String> roles;

  const _RolesWrap({required this.roles});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: roles.map((r) {
        return Chip(
          avatar: const Icon(Icons.check_circle_outline_rounded, size: 14),
          label: Text(r, style: const TextStyle(fontSize: 11)),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}

class _CompletenessBar extends StatelessWidget {
  final int percent;
  final ColorScheme colorScheme;

  const _CompletenessBar({required this.percent, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Profil Doluluk Oranı', style: TextStyle(fontSize: 12)),
            Text(
              '%$percent',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: percent / 100, borderRadius: BorderRadius.circular(6)),
      ],
    );
  }
}
