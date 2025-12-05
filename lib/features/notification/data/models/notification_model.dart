import 'package:GreenConnectMobile/features/notification/domain/entities/notification_entity.dart';

class NotificationModel {
  final String notificationId;
  final String recipientId;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final String? entityType;
  final String? entityId;

  NotificationModel({
    required this.notificationId,
    required this.recipientId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.entityType,
    this.entityId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? '',
      recipientId: json['recipientId'] ?? '',
      content: json['content'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      entityType: json['entityType'],
      entityId: json['entityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'recipientId': recipientId,
      'content': content,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'entityType': entityType,
      'entityId': entityId,
    };
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      notificationId: notificationId,
      recipientId: recipientId,
      content: content,
      isRead: isRead,
      createdAt: createdAt,
      entityType: entityType,
      entityId: entityId,
    );
  }
}
