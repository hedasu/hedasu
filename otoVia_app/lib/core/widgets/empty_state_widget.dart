import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIconContainer(theme),
            const SizedBox(height: 16),
            _buildTitle(theme),
            const SizedBox(height: 8),
            _buildMessage(theme),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              _buildActionButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(ThemeData theme) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 28,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildMessage(ThemeData theme) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: 180,
      child: FilledButton(
        onPressed: onAction,
        child: Text(actionLabel!),
      ),
    );
  }
}
