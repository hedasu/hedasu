import 'package:flutter/material.dart';
import '../models/notification_model.dart';

final NotificationController notificationController = NotificationController();

class NotificationController extends ChangeNotifier {
  NotificationController() {
    _initNotifications();
  }

  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void _initNotifications() {
    _notifications.addAll([
      NotificationModel(
        id: 'notif_01',
        title: 'Aktif Kiralama Hatırlatması',
        message: 'Porsche Taycan 4S aracınızın teslimine 30 saat kalmıştır.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.reminder,
        isRead: false,
      ),
      NotificationModel(
        id: 'notif_02',
        title: 'Yeni İndirim Kuponu!',
        message: 'Sadakat programı kapsamında %20 indirim kuponunuz hesabınıza tanımlandı.',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        type: NotificationType.coupon,
        isRead: false,
      ),
      NotificationModel(
        id: 'notif_03',
        title: 'Rezervasyon Onayı',
        message: 'Mercedes-Benz S 500 rezervasyonunuz başarıyla onaylandı.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.reservation,
        isRead: true,
      ),
      NotificationModel(
        id: 'notif_04',
        title: 'Destek Talebi Yanıtlandı',
        message: 'Havalimanı VIP Karşılama talebiniz yanıtlandı.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.support,
        isRead: true,
      ),
    ]);
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
