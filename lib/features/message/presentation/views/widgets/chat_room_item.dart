import 'package:GreenConnectMobile/features/message/domain/entities/chat_room_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatRoomItem extends StatelessWidget {
  final ChatRoomEntity chatRoom;
  final VoidCallback onTap;

  const ChatRoomItem({super.key, required this.chatRoom, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = chatRoom.unreadCount > 0;
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(spacing.screenPadding),
          decoration: BoxDecoration(
            color: hasUnread
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasUnread
                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Modern Avatar with Gradient
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.primaryColor.withValues(alpha: 0.2),
                          theme.primaryColor.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child:
                        chatRoom.partnerAvatar != null &&
                            chatRoom.partnerAvatar!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              chatRoom.partnerAvatar!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildAvatarFallback(theme),
                            ),
                          )
                        : _buildAvatarFallback(theme),
                  ),
                  // Online indicator (optional)
                  if (hasUnread)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: spacing.screenPadding),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Partner name and time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            chatRoom.partnerName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: hasUnread
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (chatRoom.lastMessageTime != null) ...[
                          SizedBox(width: spacing.screenPadding / 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.screenPadding / 2,
                              vertical: spacing.screenPadding / 4,
                            ),
                            decoration: BoxDecoration(
                              color: hasUnread
                                  ? theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    )
                                  : theme.colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _formatTime(chatRoom.lastMessageTime!),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: hasUnread
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                                fontWeight: hasUnread
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: spacing.screenPadding / 3),
                    // Last message and unread badge
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (hasUnread)
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: theme.colorScheme.primary,
                                ),
                              if (hasUnread)
                                SizedBox(width: spacing.screenPadding / 3),
                              Expanded(
                                child: Text(
                                  chatRoom.lastMessage ??
                                      s.message_no_message_yet,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: hasUnread
                                        ? theme.colorScheme.onSurface
                                        : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                    fontWeight: hasUnread
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasUnread) ...[
                          SizedBox(width: spacing.screenPadding / 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.screenPadding / 2,
                              vertical: spacing.screenPadding / 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.8,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              chatRoom.unreadCount > 99
                                  ? '99+'
                                  : chatRoom.unreadCount.toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(ThemeData theme) {
    return Center(
      child: Text(
        chatRoom.partnerName.isNotEmpty
            ? chatRoom.partnerName[0].toUpperCase()
            : '?',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      // Today - show time
      return DateFormat('HH:mm').format(time);
    } else if (diff.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      // This week - show day name
      return DateFormat('EEE').format(time);
    } else {
      // Older - show date
      return DateFormat('dd/MM/yy').format(time);
    }
  }
}
