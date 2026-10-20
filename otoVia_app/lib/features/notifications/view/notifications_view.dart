import 'package:flutter/material.dart';
import '../controller/notification_controller.dart';
import '../models/notification_model.dart';
import '../../../core/widgets/empty_state_widget.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notificationController,
      builder: (context, _) {
        final notifications = notificationController.notifications;
        return Scaffold(
          appBar: _buildAppBar(context, notifications),
          body: notifications.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.notifications_none_rounded,
                  title: 'Bildirim Yok',
                  message: 'Rezervasyon ve kampanyalarınızla ilgili bildirimler burada listelenecektir.',
                )
              : _buildList(context, notifications),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, List<dynamic> list) {
    return AppBar(
      title: const Text('Bildirimler'),
      actions: [
        if (list.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Tümünü Okundu İşaretle',
            onPressed: () => notificationController.markAllAsRead(),
          ),
      ],
    );
  }

  Widget _buildList(BuildContext context, List<dynamic> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final n = notifications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildNotificationTile(context, n),
        );
      },
    );
  }

  Widget _buildNotificationTile(BuildContext context, NotificationModel n) {
    final theme = Theme.of(context);
    return Card(
      color: n.isRead ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        leading: _buildIcon(n.type),
        title: Text(
          n.title,
          style: TextStyle(
            fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          n.message,
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
        ),
        onTap: () => notificationController.markAsRead(n.id),
      ),
    );
  }

  Widget _buildIcon(NotificationType type) {
    IconData icon;
    Color color = const Color(0xFFC0B09A);
    switch (type) {
      case NotificationType.reservation:
        icon = Icons.calendar_today;
        break;
      case NotificationType.reminder:
        icon = Icons.alarm;
        color = const Color(0xFFED6C02);
        break;
      case NotificationType.coupon:
        icon = Icons.local_offer;
        color = const Color(0xFF2E7D32);
        break;
      case NotificationType.support:
        icon = Icons.support_agent;
        break;
      case NotificationType.campaign:
        icon = Icons.campaign;
        break;
    }
    return Icon(icon, color: color, size: 22);
  }
}
