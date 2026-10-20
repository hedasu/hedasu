import 'package:flutter/material.dart';
import '../controller/messaging_controller.dart';
import '../models/chat_message_model.dart';
import '../widgets/chat_bubble.dart';

class MessagingView extends StatefulWidget {
  final MessagingController controller;
  final String title;

  const MessagingView({
    super.key,
    required this.controller,
    this.title = 'Ayşe Yılmaz (Mentor)',
  });

  @override
  State<MessagingView> createState() => _MessagingViewState();
}

class _MessagingViewState extends State<MessagingView> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _inputController.text;
    if (text.trim().isNotEmpty) {
      widget.controller.sendMessage(text);
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _MessageList(controller: widget.controller)),
            _MessageInput(controller: _inputController, onSend: _handleSend),
          ],
        ),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final MessagingController controller;

  const _MessageList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ChatMessageModel>>(
      valueListenable: controller.messages,
      builder: (context, messages, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return ChatBubble(message: messages[index]);
          },
        );
      },
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Mesajınızı yazın...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded),
            color: Theme.of(context).colorScheme.primary,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
