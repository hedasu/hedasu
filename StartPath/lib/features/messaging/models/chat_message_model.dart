/// Mesajlaşma İleti Modeli
class ChatMessageModel {
  final String id;
  final String senderName;
  final String text;
  final DateTime sentAt;
  final bool isMe;

  const ChatMessageModel({
    required this.id,
    required this.senderName,
    required this.text,
    required this.sentAt,
    required this.isMe,
  });

  static List<ChatMessageModel> get samples => [
        ChatMessageModel(
          id: 'msg_1',
          senderName: 'Ayşe Yılmaz (Mentor)',
          text: 'Merhaba Can, PayWise projesinin finansal projeksiyonunu inceledim. Oldukça umut vadediyor.',
          sentAt: DateTime.now().subtract(const Duration(hours: 3)),
          isMe: false,
        ),
        ChatMessageModel(
          id: 'msg_2',
          senderName: 'Ben',
          text: 'Teşekkürler Ayşe Hanım! Yarın için müsait bir görüşme saatiniz var mı?',
          sentAt: DateTime.now().subtract(const Duration(hours: 2)),
          isMe: true,
        ),
        ChatMessageModel(
          id: 'msg_3',
          senderName: 'Ayşe Yılmaz (Mentor)',
          text: 'Yarın 14:00 benim için uygun. Görüşme linkini randevu talebi üzerinden onaylayabilirsin.',
          sentAt: DateTime.now().subtract(const Duration(minutes: 45)),
          isMe: false,
        ),
      ];
}
