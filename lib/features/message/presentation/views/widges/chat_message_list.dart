import 'package:GreenConnectMobile/features/message/presentation/views/chat_class.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/widges/chat_message_bubble.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;

  const ChatMessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.all(spacing.screenPadding),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[messages.length - 1 - index];
        return ChatMessageBubble(message: msg);
      },
    );
  }
}
