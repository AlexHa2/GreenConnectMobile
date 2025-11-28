import 'package:GreenConnectMobile/features/message/presentation/views/message_class.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/widgets/message_item.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const List<Message> dummyMessages = [
  Message(
    sender: "Jane Doe",
    lastMessage: "Tuyệt vời! Hẹn gặp bạn ở đó nhé.",
    time: "10:30 AM",
    avatarInitials: "JD",
    isUnread: true,
  ),
  Message(
    sender: "GreenConnect Team",
    lastMessage: "Cập nhật chính sách cộng đồng mới...",
    time: "9:15 AM",
    avatarInitials: "GC",
    isUnread: true,
  ),
  Message(
    sender: "Alex Johnson",
    lastMessage: "Cảm ơn bạn đã tham gia dự án.",
    time: "Hôm qua",
    avatarInitials: "AJ",
  ),
  Message(
    sender: "Sự kiện Tái chế",
    lastMessage: "Đừng quên sự kiện cuối tuần này!",
    time: "Thứ 3",
    avatarInitials: "SE",
  ),
  Message(
    sender: "Michael Brown",
    lastMessage: "Tôi đã gửi bạn tài liệu rồi nhé.",
    time: "Thứ 2",
    avatarInitials: "MB",
  ),
];

class MessageListScreen extends StatelessWidget {
  final List<Message> messages;

  const MessageListScreen({super.key, this.messages = dummyMessages});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(s.message),
        leading: BackButton(
          onPressed: () {
            context.go('/household-home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Xử lý tìm kiếm tin nhắn ở đây
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          vertical: spacing.screenPadding,
        ),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return MessageItem(message: message);
        },
        separatorBuilder: (context, index) => Divider(
          color: theme.dividerColor,
          height: 1,
          indent: spacing.screenPadding + 56 + 16, // padding + avatar + space
          endIndent: spacing.screenPadding,
        ),
      ),
    );
  }
}
