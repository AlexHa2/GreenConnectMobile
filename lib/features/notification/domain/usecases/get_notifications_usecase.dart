import 'package:GreenConnectMobile/features/notification/domain/entities/paginated_notification_entity.dart';
import 'package:GreenConnectMobile/features/notification/domain/repository/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository _repository;

  GetNotificationsUsecase(this._repository);

  Future<PaginatedNotificationEntity> call({
    required int pageNumber,
    required int pageSize,
  }) async {
    return await _repository.getNotifications(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
