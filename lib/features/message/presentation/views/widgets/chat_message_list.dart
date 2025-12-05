import 'package:GreenConnectMobile/features/message/domain/entities/message_entity.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/widgets/message_bubble.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends StatelessWidget {
  final List<MessageEntity> messages;
  final String currentUserId;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final VoidCallback onRefresh;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
    this.isLoadingMore = false,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    // Reverse messages: oldest first (top), newest last (bottom)
    final reversedMessages = messages.reversed.toList();

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: theme.primaryColor,
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: spacing.screenPadding,
          bottom: spacing.screenPadding,
          left: spacing.screenPadding / 2,
          right: spacing.screenPadding / 2,
        ),
        itemCount: reversedMessages.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Loading indicator at top when loading more old messages
          if (isLoadingMore && index == 0) {
            return Padding(
              padding: EdgeInsets.all(spacing.screenPadding),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: theme.primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              ),
            );
          }

          // Adjust index if loading indicator is shown
          final messageIndex = isLoadingMore ? index - 1 : index;
          final message = reversedMessages[messageIndex];

          // Animate message appearance
          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: MessageBubble(
              message: message,
              currentUserId: currentUserId,
            ),
          );
        },
      ),
    );
  }
}
