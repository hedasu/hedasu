/// Bildirim Türü Sabiti (NotificationType)
enum NotificationType {
  /// Rezervasyon onay veya değişiklik bildirimleri
  reservation,
  /// Kiralama teslim saati hatırlatmaları
  reminder,
  /// Yeni kupon ve indirim kazanım bildirimleri
  coupon,
  /// Müşteri destek ve bilet yanıtları
  support,
  /// Genel kampanya ve duyurular
  campaign,
}

/// otoVia Bildirim Veri Modeli (NotificationModel)
///
/// Kullanıcıya iletilen sistem bildirimlerini, başlık, detay mesajı,
/// tarih damgası, bildirim türü ve okunma (isRead) durumunu saklar.
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isUsed = false,
    this.isRead = false,
  });

  /// Benzersiz bildirim kimliği
  final String id;

  /// Bildirim başlığı (ör. 'Kiralama Onaylandı')
  final String title;

  /// Bildirimin detaylı açıklaması
  final String message;

  /// Bildirimin gönderildiği tarih ve saat
  final DateTime timestamp;

  /// Bildirim kategorisi / tipi
  final NotificationType type;

  /// Bildirimin kullanıcı tarafından okunup okunmadığı
  final bool isRead;

  final bool isUsed;

  /// Okunma durumunu güncellemek için kopya nesne üretir
  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}
