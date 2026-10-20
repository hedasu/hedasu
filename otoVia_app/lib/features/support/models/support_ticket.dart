/// Destek Talebi Durumu Sabiti (TicketStatus)
enum TicketStatus {
  pending('Beklemede'),
  reviewing('İnceleniyor'),
  answered('Yanıtlandı'),
  resolved('Çözüldü');

  const TicketStatus(this.displayName);
  /// Arayüzde görüntülenecek Türkçe durum metni
  final String displayName;
}

/// otoVia Müşteri Destek Talebi Modeli (SupportTicketModel)
///
/// Kullanıcının oluşturduğu yardım taleplerini, konusunu, mesajını,
/// durumunu ve müşteri temsilcisinin yanıtını saklar.
class SupportTicketModel {
  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
    this.reply,
  });

  /// Destek talebi takip numarası
  final String id;

  /// Talep konusu (ör. 'Havalimanı Karşılama Talebi')
  final String subject;

  /// Kullanıcının yazdığı mesaj metni
  final String message;

  /// Destek talebinin güncel durumu (Beklemede, İnceleniyor, Yanıtlandı, Çözüldü)
  final TicketStatus status;

  /// Talebin oluşturulma tarihi
  final DateTime createdAt;

  /// Müşteri temsilcisinden gelen yanıt metni
  final String? reply;

  /// Talep durumunu veya yanıtını güncellemek için yeni kopya oluşturur
  SupportTicketModel copyWith({
    TicketStatus? status,
    String? reply,
  }) {
    return SupportTicketModel(
      id: id,
      subject: subject,
      message: message,
      status: status ?? this.status,
      createdAt: createdAt,
      reply: reply ?? this.reply,
    );
  }
}
