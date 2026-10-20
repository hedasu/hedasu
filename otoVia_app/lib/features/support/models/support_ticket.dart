enum TicketStatus {
  pending('Beklemede'),
  reviewing('İnceleniyor'),
  answered('Yanıtlandı'),
  resolved('Çözüldü');

  const TicketStatus(this.displayName);
  final String displayName;
}

class SupportTicketModel {
  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
    this.reply,
  });

  final String id;
  final String subject;
  final String message;
  final TicketStatus status;
  final DateTime createdAt;
  final String? reply;

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
