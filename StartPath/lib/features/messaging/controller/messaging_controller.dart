import 'package:flutter/foundation.dart';
import '../models/chat_message_model.dart';

/// Mesajlaşma Kontrolcüsü
class MessagingController {
  final ValueNotifier<List<ChatMessageModel>> messages =
      ValueNotifier<List<ChatMessageModel>>(ChatMessageModel.samples);

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final newMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: 'Ben',
      text: text.trim(),
      sentAt: DateTime.now(),
      isMe: true,
    );
    messages.value = [...messages.value, newMsg];
  }

  void dispose() {
    messages.dispose();
  }
}
