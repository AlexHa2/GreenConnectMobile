import 'package:GreenConnectMobile/features/message/presentation/views/chat_class.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/message_class.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    final titleStyle = theme.textTheme.titleLarge;

    final subtitleStyle = message.isUnread
        ? theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          )
        : theme.textTheme.bodyMedium;

    final timeStyle = message.isUnread
        ? theme.textTheme.labelLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          )
        : theme.textTheme.labelLarge;

    const List<ChatMessage> dummyChatMessages = [
      ChatMessage(
        text: "Chào bạn, bạn có thể giúp tôi với dự án GreenConnect không?",
        time: "10:30 AM",
        isSentByMe: false,
      ),
      ChatMessage(
        text: "Chào! Tất nhiên rồi, bạn cần hỗ trợ về vấn đề gì?",
        time: "10:31 AM",
        isSentByMe: true,
      ),
      ChatMessage(
        text:
            "Tôi đang gặp chút rắc rối với việc phân loại rác thải tại nguồn.",
        time: "10:31 AM",
        isSentByMe: false,
      ),
      ChatMessage(
        text:
            "Bạn có thể gửi cho tôi hình ảnh của các loại rác bạn đang có không? Tôi sẽ hướng dẫn chi tiết.",
        time: "10:32 AM",
        isSentByMe: true,
      ),
      ChatMessage(
        text: "Tuyệt vời! Cảm ơn bạn nhiều nhé.",
        time: "10:33 AM",
        isSentByMe: false,
      ),
    ];
    return ListTile(
      onTap: () {
        context.pushNamed(
          'chat-detail',
          extra: {
            "name": "Jane Doe",
            "avatar": "https://i.pravatar.cc/100",
            "messages": dummyChatMessages,
          },
        );
      },
      contentPadding: EdgeInsets.symmetric(
        horizontal: spacing.screenPadding,
        vertical: 4,
      ),
      leading: CircleAvatar(
        radius: spacing.screenPadding * 2,
        backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
        child: Text(
          message.avatarInitials,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
          ),
        ),
      ),
      title: Text(message.sender, style: titleStyle),
      subtitle: Text(
        message.lastMessage,
        style: subtitleStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(message.time, style: timeStyle),
          if (message.isUnread) ...[
            SizedBox(height: spacing.screenPadding / 2),
            Container(
              width: spacing.screenPadding,
              height: spacing.screenPadding,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ] else ...[
            SizedBox(height: spacing.screenPadding),
          ],
        ],
      ),
    );
  }
}
