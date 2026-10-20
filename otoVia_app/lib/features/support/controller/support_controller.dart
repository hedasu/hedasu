import 'package:flutter/material.dart';
import '../models/support_ticket.dart';

final SupportController supportController = SupportController();

class SupportController extends ChangeNotifier {
  SupportController() {
    _initTickets();
  }

  final List<SupportTicketModel> _tickets = [];
  final List<Map<String, dynamic>> _liveChatMessages = [
    {
      'sender': 'agent',
      'message': 'Merhaba! otoVia VIP Canlı Desteğe hoş geldiniz. Size nasıl yardımcı olabilirim?',
      'time': '16:00',
    },
  ];

  List<SupportTicketModel> get tickets => List.unmodifiable(_tickets);
  List<Map<String, dynamic>> get liveChatMessages => List.unmodifiable(_liveChatMessages);

  void _initTickets() {
    _tickets.addAll([
      SupportTicketModel(
        id: 'tkt_101',
        subject: 'Havalimanı VIP Karşılama Noktası',
        message: 'IST Dış Hatlar terminalinde karşılama görevlisi nerede bekliyor olacak?',
        status: TicketStatus.answered,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        reply: 'Sayın Deniz Yılmaz, 9 numaralı kapı çıkışında otoVia VIP deskinde görevlimiz adınızla hazır bulunacaktır.',
      ),
      SupportTicketModel(
        id: 'tkt_102',
        subject: 'Elektrikli Araç Şarj Ağı Kullanımı',
        message: 'Porsche Taycan için Trugo ve ZES şarj kartları torpido gözünde mi bulunuyor?',
        status: TicketStatus.resolved,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        reply: 'Evet, tüm anlaşmalı şarj kartları torpido gözündeki deri otoVia evrak dosyasında mevcuttur.',
      ),
    ]);
  }

  void createTicket(String subject, String message) {
    final newTicket = SupportTicketModel(
      id: 'tkt_${DateTime.now().millisecondsSinceEpoch}',
      subject: subject,
      message: message,
      status: TicketStatus.pending,
      createdAt: DateTime.now(),
    );
    _tickets.insert(0, newTicket);
    notifyListeners();
  }

  void sendLiveChatMessage(String text) {
    if (text.trim().isEmpty) return;
    _liveChatMessages.add({
      'sender': 'user',
      'message': text,
      'time': 'Şimdi',
    });
    notifyListeners();

    // Otomatik asistan simülasyon cevabı
    Future.delayed(const Duration(seconds: 1), () {
      _liveChatMessages.add({
        'sender': 'agent',
        'message': 'Mesajınız otoVia Operasyon Ekibine iletildi. Yetkili danışmanımız anlık olarak ilgilenmektedir.',
        'time': 'Şimdi',
      });
      notifyListeners();
    });
  }
}
