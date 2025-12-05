import 'package:GreenConnectMobile/features/notification/domain/repository/notification_repository.dart';

class MarkNotificationAsReadUsecase {
  final NotificationRepository _repository;

  MarkNotificationAsReadUsecase(this._repository);

  Future<bool> call(String notificationId) async {
    return await _repository.markNotificationAsRead(notificationId);
  }
}
