import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../../../core/constants/app_colors.dart';

class NotificationItemCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItemCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationIcon(type: notification.type),
              const SizedBox(width: 14),
              Expanded(
                child: _NotificationTextContent(notification: notification),
              ),
              if (!notification.isRead) ...[
                const SizedBox(width: 8),
                const _UnreadDot(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final NotificationType type;

  const _NotificationIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.badge:
        icon = Icons.emoji_events_rounded;
        color = AppColors.accentGold;
      case NotificationType.pet:
        icon = Icons.pets_rounded;
        color = AppColors.accentOrange;
      case NotificationType.streak:
        icon = Icons.local_fire_department_rounded;
        color = AppColors.accentPink;
      case NotificationType.habit:
        icon = Icons.check_circle_outline_rounded;
        color = AppColors.darkMint;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _NotificationTextContent extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTextContent({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          notification.message,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(top: 6),
      decoration: const BoxDecoration(
        color: AppColors.darkMint,
        shape: BoxShape.circle,
      ),
    );
  }
}
