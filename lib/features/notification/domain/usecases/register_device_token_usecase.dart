import 'package:GreenConnectMobile/features/notification/domain/repository/notification_repository.dart';

class RegisterDeviceTokenUsecase {
  final NotificationRepository _repository;

  RegisterDeviceTokenUsecase(this._repository);

  Future<bool> call(String deviceToken) async {
    return await _repository.registerDeviceToken(deviceToken);
  }
}
