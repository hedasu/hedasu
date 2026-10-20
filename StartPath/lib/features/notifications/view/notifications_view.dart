import 'package:flutter/material.dart';
import '../../../core/widgets/app_empty_view.dart';
import '../controller/notifications_controller.dart';
import '../models/app_notification_model.dart';

class NotificationsView extends StatelessWidget {
  final NotificationsController controller;

  const NotificationsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        actions: [
          IconButton(
            tooltip: 'Tümünü Okundu Say',
            icon: const Icon(Icons.done_all_rounded),
            onPressed: controller.markAllAsRead,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<AppNotificationModel>>(
          valueListenable: controller.notifications,
          builder: (context, list, _) {
            if (list.isEmpty) {
              return const AppEmptyView(
                icon: Icons.notifications_off_outlined,
                title: 'Bildirim Yok',
                subtitle: 'Şu anda okunmamış bir bildiriminiz bulunmuyor.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _NotificationTile(
                  notification: list[index],
                  onTap: () => controller.markAsRead(list[index].id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: notification.isRead
          ? colorScheme.surface
          : colorScheme.primaryContainer.withValues(alpha: 0.25),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: notification.type.color.withValues(alpha: 0.15),
          child: Icon(notification.type.icon, color: notification.type.color, size: 20),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(
          notification.body,
          style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        trailing: Text(
          notification.timeAgo,
          style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        onTap: onTap,
      ),
    );
  }
}
