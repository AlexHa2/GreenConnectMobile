import 'package:GreenConnectMobile/features/notification/domain/entities/paginated_notification_entity.dart';

abstract class NotificationRepository {
  /// Register device token for push notifications
  Future<bool> registerDeviceToken(String deviceToken);

  /// Get paginated notifications
  Future<PaginatedNotificationEntity> getNotifications({
    required int pageNumber,
    required int pageSize,
  });

  /// Mark a notification as read
  Future<bool> markNotificationAsRead(String notificationId);
}
