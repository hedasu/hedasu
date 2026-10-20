import 'package:flutter/foundation.dart';
import '../models/app_notification_model.dart';

/// Bildirim Kontrolcüsü
class NotificationsController {
  final ValueNotifier<List<AppNotificationModel>> notifications =
      ValueNotifier<List<AppNotificationModel>>(AppNotificationModel.samples);

  int get unreadCount => notifications.value.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    notifications.value = notifications.value.map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
  }

  void markAllAsRead() {
    notifications.value = notifications.value.map((n) => n.copyWith(isRead: true)).toList();
  }

  void dispose() {
    notifications.dispose();
  }
}
