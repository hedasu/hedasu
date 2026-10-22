import 'package:flutter/material.dart';
import '../../../core/widgets/app_scope.dart';
import '../widgets/notification_item_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifCtrl = AppScope.of(context).notificationController;

    return ListenableBuilder(
      listenable: notifCtrl,
      builder: (context, _) {
        final notifications = notifCtrl.notifications;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bildirimler'),
            actions: [
              if (notifCtrl.unreadCount > 0)
                TextButton(
                  onPressed: notifCtrl.markAllAsRead,
                  child: const Text('Tümünü Oku'),
                ),
            ],
          ),
          body: SafeArea(
            child: notifications.isEmpty
                ? const _EmptyNotifications()
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final n = notifications[index];
                      return NotificationItemCard(
                        notification: n,
                        onTap: () => notifCtrl.markAsRead(n.id),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off_outlined, size: 56),
          const SizedBox(height: 16),
          const Text(
            'Bildirim Yok',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Yeni bir gelişme olduğunda burada görebilirsin.',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
