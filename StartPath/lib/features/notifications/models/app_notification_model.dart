import 'package:flutter/material.dart';

/// Bildirim Türü
enum NotificationType {
  application(Icons.assignment_turned_in_rounded, Colors.blue),
  mentor(Icons.school_rounded, Colors.purple),
  opportunity(Icons.hourglass_top_rounded, Colors.amber),
  message(Icons.chat_bubble_outline_rounded, Colors.teal);

  final IconData icon;
  final Color color;
  const NotificationType(this.icon, this.color);
}

/// Uygulama İçi Bildirim Modeli
class AppNotificationModel {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    required this.isRead,
  });

  AppNotificationModel copyWith({bool? isRead}) {
    return AppNotificationModel(
      id: id,
      title: title,
      body: body,
      timeAgo: timeAgo,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }

  static List<AppNotificationModel> get samples => const [
        AppNotificationModel(
          id: 'notif_1',
          title: 'Yeni Mentor Mesajı',
          body: 'Ayşe Yılmaz PayWise projeniz için görüşme teklifine yanıt verdi.',
          timeAgo: '45 dk önce',
          type: NotificationType.message,
          isRead: false,
        ),
        AppNotificationModel(
          id: 'notif_2',
          title: 'Başvuru Durumu Güncellendi',
          body: 'HealthPulse AI başvurunuz "İnceleniyor" aşamasına alındı.',
          timeAgo: '2 saat önce',
          type: NotificationType.application,
          isRead: false,
        ),
        AppNotificationModel(
          id: 'notif_3',
          title: 'Son Başvuru Tarihi Yaklaşıyor',
          body: 'TÜBİTAK 1512 BİGG hibe programı için son 15 gün.',
          timeAgo: 'Dün',
          type: NotificationType.opportunity,
          isRead: true,
        ),
      ];
}
