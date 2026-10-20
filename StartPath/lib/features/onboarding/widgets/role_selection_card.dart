import 'package:flutter/material.dart';
import '../models/onboarding_role_model.dart';

/// Rol Seçim Kartı (<40 satır build)
class RoleSelectionCard extends StatelessWidget {
  final OnboardingRoleModel role;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBox(icon: role.icon, isSelected: isSelected, colorScheme: colorScheme),
              const SizedBox(width: 14),
              Expanded(child: _InfoText(role: role, theme: theme, colorScheme: colorScheme)),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final ColorScheme colorScheme;

  const _IconBox({required this.icon, required this.isSelected, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant),
    );
  }
}

class _InfoText extends StatelessWidget {
  final OnboardingRoleModel role;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _InfoText({required this.role, required this.theme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          role.title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          role.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
