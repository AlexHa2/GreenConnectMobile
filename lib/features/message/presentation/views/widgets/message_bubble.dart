import 'package:GreenConnectMobile/features/message/domain/entities/message_entity.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final String currentUserId;

  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isSentByMe = message.isSentByMe(currentUserId);
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    // Debug: Print to check if alignment is correct
    if (kDebugMode) {
      print('💬 Message from ${message.senderName}: isSentByMe=$isSentByMe, senderId=${message.senderId}, currentUserId=$currentUserId');
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.screenPadding,
        vertical: spacing.screenPadding / 3,
      ),
      child: Row(
        mainAxisAlignment: isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar for RECEIVED messages (LEFT side)
          if (!isSentByMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.primaryColor.withValues(alpha: 0.2),
                    theme.primaryColor.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  message.senderName.isNotEmpty
                      ? message.senderName[0].toUpperCase()
                      : '?',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: spacing.screenPadding / 2),
          ],
          // Message Bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                gradient: isSentByMe
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withValues(alpha: 0.85),
                        ],
                      )
                    : null,
                color: isSentByMe
                    ? null
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isSentByMe ? 20 : 4),
                  bottomRight: Radius.circular(isSentByMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSentByMe
                        ? theme.primaryColor.withValues(alpha: 0.2)
                        : theme.shadowColor.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.screenPadding,
                  vertical: spacing.screenPadding / 1.2,
                ),
                child: Column(
                  crossAxisAlignment: isSentByMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Sender name ONLY for received messages (LEFT side)
                    if (!isSentByMe)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: spacing.screenPadding / 4,
                        ),
                        child: Text(
                          message.senderName,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    // Message content
                    Text(
                      message.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSentByMe
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: spacing.screenPadding / 4),
                    // Timestamp and read status
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSentByMe
                                ? theme.colorScheme.onPrimary.withValues(
                                    alpha: 0.8,
                                  )
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                          ),
                        ),
                        if (isSentByMe) ...[
                          SizedBox(width: spacing.screenPadding / 4),
                          Icon(
                            message.isRead
                                ? Icons.done_all_rounded
                                : Icons.done_rounded,
                            size: 16,
                            color: message.isRead
                                ? theme.colorScheme.secondary.withValues(
                                    alpha: 0.9,
                                  )
                                : theme.colorScheme.onPrimary.withValues(
                                    alpha: 0.7,
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
}
