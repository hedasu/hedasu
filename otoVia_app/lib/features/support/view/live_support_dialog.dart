import 'package:flutter/material.dart';
import '../controller/support_controller.dart';

/// VIP Canlı Destek Alt Sayfası (LiveSupportDialog)
///
/// Kullanıcı aktif kiralaması veya araç tercihi sırasında 7/24 operasyon ekibiyle
/// anlık mesajlaşabileceği şık bir modal alt sohbet penceresidir.
class LiveSupportDialog extends StatefulWidget {
  const LiveSupportDialog({super.key});

  @override
  State<LiveSupportDialog> createState() => _LiveSupportDialogState();
}

class _LiveSupportDialogState extends State<LiveSupportDialog> {
  // Mesaj metni giriş kontrolcüsü
  final TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Üst temsilci durum çubuğu
          _buildHeader(context),
          const Divider(height: 1),
          // Mesaj geçmişi baloncukları listesi
          Expanded(child: _buildMessagesList()),
          const Divider(height: 1),
          // Mesaj yazma ve gönderme çubuğu
          _buildInputBar(context),
        ],
      ),
    );
  }

  /// Canlı destek temsilcisi bilgisi ve kapatma butonu
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFC0B09A),
            child: Icon(Icons.support_agent, color: Colors.black),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('otoVia VIP Canlı Destek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Çevrim içi • Ortalama yanıt 1 dk', style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32))),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  /// Mesaj baloncukları listesi (Kullanıcı sağda, temsilci solda)
  Widget _buildMessagesList() {
    return ListenableBuilder(
      listenable: supportController,
      builder: (context, _) {
        final messages = supportController.liveChatMessages;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final m = messages[index];
            final isUser = m['sender'] == 'user';
            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
                decoration: BoxDecoration(
                  color: isUser
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  m['message'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: isUser
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Mesaj giriş alanı ve gönder butonu
  Widget _buildInputBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgController,
                decoration: const InputDecoration(
                  hintText: 'Mesajınızı yazınız...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: const Icon(Icons.send_rounded),
              onPressed: () {
                final txt = _msgController.text.trim();
                if (txt.isNotEmpty) {
                  supportController.sendLiveChatMessage(txt);
                  _msgController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
