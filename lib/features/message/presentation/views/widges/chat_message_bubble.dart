import 'package:GreenConnectMobile/features/message/presentation/views/chat_class.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final isMe = message.isSentByMe;

    final bubbleColor = isMe ? theme.primaryColor : theme.cardColor;
    final textColor = isMe
        ? theme.elevatedButtonTheme.style?.foregroundColor?.resolve({})
        : theme.textTheme.bodyLarge?.color;

    final bubbleRadius = Radius.circular(spacing.screenPadding * 1.5);
    final smallRadius = Radius.circular(spacing.screenPadding / 3);

    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isMe ? spacing.screenPadding * 5 : 0,
        right: isMe ? 0 : spacing.screenPadding * 5,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.screenPadding * 1.2,
          vertical: spacing.screenPadding,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: bubbleRadius,
            topRight: bubbleRadius,
            bottomLeft: isMe ? bubbleRadius : smallRadius,
            bottomRight: isMe ? smallRadius : bubbleRadius,
          ),
          border: isMe
              ? null
              : Border.all(color: theme.dividerColor, width: 0.5),
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
        ),
      ),
    );
  }
}
