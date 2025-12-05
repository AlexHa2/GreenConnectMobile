class NotificationEntity {
  final String notificationId;
  final String recipientId;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final String? entityType;
  final String? entityId;

  NotificationEntity({
    required this.notificationId,
    required this.recipientId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.entityType,
    this.entityId,
  });
}
