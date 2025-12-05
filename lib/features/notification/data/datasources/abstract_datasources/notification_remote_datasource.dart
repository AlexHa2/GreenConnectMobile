import 'package:GreenConnectMobile/features/notification/data/models/paginated_notification_model.dart';

abstract class NotificationRemoteDataSource {
  /// Register device token for push notifications
  Future<bool> registerDeviceToken(String deviceToken);

  /// Get paginated notifications
  Future<PaginatedNotificationModel> getNotifications({
    required int pageNumber,
    required int pageSize,
  });

  /// Mark a notification as read
  Future<bool> markNotificationAsRead(String notificationId);
}
