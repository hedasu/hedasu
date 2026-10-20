import 'package:flutter/material.dart';
import '../controller/support_controller.dart';
import '../models/support_ticket.dart';
import '../../../core/widgets/status_badge.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yardım & Destek'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Destek Taleplerim'),
              Tab(text: 'Sıkça Sorulan Sorular'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTicketsTab(context),
            _buildFaqTab(context),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreateTicketDialog(context),
          icon: const Icon(Icons.add_comment_outlined),
          label: const Text('Yeni Talep'),
        ),
      ),
    );
  }

  Widget _buildTicketsTab(BuildContext context) {
    return ListenableBuilder(
      listenable: supportController,
      builder: (context, _) {
        final tickets = supportController.tickets;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final t = tickets[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusBadge(t.status),
                          Text(
                            '${t.createdAt.day}.${t.createdAt.month}.${t.createdAt.year}',
                            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(t.subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(t.message, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      if (t.reply != null) ...[
                        const Divider(height: 16),
                        Text('otoVia Yanıtı: ${t.reply}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFC0B09A))),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusBadge(TicketStatus status) {
    Color bg;
    switch (status) {
      case TicketStatus.pending:
        bg = const Color(0xFFED6C02);
        break;
      case TicketStatus.reviewing:
        bg = const Color(0xFF0288D1);
        break;
      case TicketStatus.answered:
        bg = const Color(0xFF2E7D32);
        break;
      case TicketStatus.resolved:
        bg = const Color(0xFF62625F);
        break;
    }
    return StatusBadge(text: status.displayName, backgroundColor: bg, textColor: Colors.white);
  }

  Widget _buildFaqTab(BuildContext context) {
    const faqs = [
      {'q': 'Kiralama için hangi belgeler gereklidir?', 'a': 'T.C. Kimlik kartınız, ilgili araç sınıfına uygun geçerli sürücü belgeniz ve adınıza düzenlenmiş kredi kartı yeterlidir.'},
      {'q': 'Depozito iadesi ne zaman yapılır?', 'a': 'Araç teslimatı eksiksiz onaylandıktan sonra provizyon blokajı bankanıza bağlı olarak 1-3 iş günü içinde kaldırılır.'},
      {'q': 'Motosiklet veya ticari araç kiralayabilir miyim?', 'a': 'Evet, A/A2 ehliyet ile motosiklet, B ehliyet ile binek, SUV ve 3.5 tona kadar hafif ticari araçlar kiralanabilir.'},
      {'q': 'Kiralamayı erken bitirebilir miyim?', 'a': 'Evet, dilediğiniz zaman aracı belirlenen teslim noktasına bırakarak teslim alma/etme sürecini başlatabilirsiniz.'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: faqs.map((f) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ExpansionTile(
          title: Text(f['q']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(f['a']!, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ),
          ],
        ),
      )).toList(),
    );
  }

  void _showCreateTicketDialog(BuildContext context) {
    final subCtrl = TextEditingController();
    final msgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni Destek Talebi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: subCtrl, decoration: const InputDecoration(labelText: 'Konu Başlığı')),
            const SizedBox(height: 12),
            TextField(controller: msgCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Talebinizin Detayı')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          FilledButton(
            onPressed: () {
              if (subCtrl.text.isNotEmpty && msgCtrl.text.isNotEmpty) {
                supportController.createTicket(subCtrl.text.trim(), msgCtrl.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Destek talebiniz oluşturuldu.')),
                );
              }
            },
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
  }
}
