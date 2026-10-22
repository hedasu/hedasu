import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationController extends ChangeNotifier {
  late List<NotificationModel> _notifications;

  NotificationController() {
    final now = DateTime.now();
    _notifications = [
      NotificationModel(
        id: 'notif_1',
        title: '🔥 16 Günlük İrade!',
        message: 'Harika gidiyorsun! 21 Gün Bilimsel Alışkanlık rozetine sadece 5 gün kaldı.',
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
        type: NotificationType.streak,
      ),
      NotificationModel(
        id: 'notif_2',
        title: '🐱 Mırnav Seni Özledi!',
        message: 'Evcil hayvanın seni bekliyor. Dolaptaki taze yiyeceklerle onu besleyip seviye atlatabilirsin.',
        timestamp: now.subtract(const Duration(hours: 4)),
        isRead: false,
        type: NotificationType.pet,
      ),
      NotificationModel(
        id: 'notif_3',
        title: '🎖️ 2. Hafta İstikrar Rozeti!',
        message: 'Tebrikler! 14 günlük kesintisiz serinle +75 Rozet kazandın.',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        type: NotificationType.badge,
      ),
      NotificationModel(
        id: 'notif_4',
        title: '💧 Su Vakti',
        message: 'Günün hedefine ulaşmak için bir bardak ferahlatıcı su içmeyi unutma.',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        type: NotificationType.habit,
      ),
    ];
  }

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    _notifications = _notifications.map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
    notifyListeners();
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void clearAll() {
    _notifications = [];
    notifyListeners();
  }
}
