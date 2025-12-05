import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/notification/domain/entities/notification_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.screenPadding.toDouble()),
        decoration: BoxDecoration(
          color: isRead
              ? theme.colorScheme.surface
              : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(notification.entityType, theme),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForType(notification.entityType),
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
            SizedBox(width: spacing.screenPadding.toDouble()),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.content,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: spacing.screenPadding / 4),
                  Text(
                    TimeAgoHelper.format(context, notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  if (notification.entityType != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeTagColor(notification.entityType, theme),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getLocalizedEntityType(context, notification.entityType!),
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Unread indicator
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String? entityType) {
    if (entityType == null) return Icons.notifications;
    switch (entityType.toLowerCase()) {
      case 'post':
        return Icons.article;
      case 'offer':
        return Icons.local_offer;
      case 'transaction':
        return Icons.receipt_long;
      case 'message':
        return Icons.message;
      case 'chat':
        return Icons.chat;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconBackgroundColor(String? entityType, ThemeData theme) {
    if (entityType == null) {
      return theme.colorScheme.secondary.withValues(alpha: 0.7);
    }
    switch (entityType.toLowerCase()) {
      case 'post':
        return theme.colorScheme.primary;
      case 'offer':
        return theme.colorScheme.tertiary;
      case 'transaction':
        return theme.colorScheme.secondary;
      case 'message':
      case 'chat':
        return theme.colorScheme.primary.withValues(alpha: 0.8);
      default:
        return theme.colorScheme.secondary.withValues(alpha: 0.7);
    }
  }

  Color _getTypeTagColor(String? entityType, ThemeData theme) {
    if (entityType == null) {
      return theme.colorScheme.secondary.withValues(alpha: 0.6);
    }
    switch (entityType.toLowerCase()) {
      case 'post':
        return theme.colorScheme.primary.withValues(alpha: 0.8);
      case 'offer':
        return theme.colorScheme.tertiary.withValues(alpha: 0.8);
      case 'transaction':
        return theme.colorScheme.secondary.withValues(alpha: 0.8);
      case 'message':
      case 'chat':
        return theme.colorScheme.primary.withValues(alpha: 0.7);
      default:
        return theme.colorScheme.secondary.withValues(alpha: 0.6);
    }
  }

  String _getLocalizedEntityType(BuildContext context, String entityType) {
    final s = S.of(context)!;
    switch (entityType.toLowerCase()) {
      case 'post':
        return s.notification_type_post.toUpperCase();
      case 'offer':
        return s.notification_type_offer.toUpperCase();
      case 'transaction':
        return s.notification_type_transaction.toUpperCase();
      case 'message':
        return s.notification_type_message.toUpperCase();
      case 'chat':
        return s.notification_type_chat.toUpperCase();
      case 'feedback':
        return s.notification_type_feedback.toUpperCase();
      case 'complaint':
        return s.notification_type_complaint.toUpperCase();
      default:
        return entityType.toUpperCase();
    }
  }
}
