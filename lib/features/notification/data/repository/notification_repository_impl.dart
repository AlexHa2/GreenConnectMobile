import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/notification/data/datasources/abstract_datasources/notification_remote_datasource.dart';
import 'package:GreenConnectMobile/features/notification/domain/entities/paginated_notification_entity.dart';
import 'package:GreenConnectMobile/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl(this.remote);

  @override
  Future<bool> registerDeviceToken(String deviceToken) {
    return guard(() async {
      return await remote.registerDeviceToken(deviceToken);
    });
  }

  @override
  Future<PaginatedNotificationEntity> getNotifications({
    required int pageNumber,
    required int pageSize,
  }) {
    return guard(() async {
      final result = await remote.getNotifications(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return result.toEntity();
    });
  }

  @override
  Future<bool> markNotificationAsRead(String notificationId) {
    return guard(() async {
      return await remote.markNotificationAsRead(notificationId);
    });
  }
}
