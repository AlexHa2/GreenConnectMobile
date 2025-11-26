import 'package:GreenConnectMobile/features/profile/domain/repository/profile_repository.dart';

class UpdateMeAvatarUseCase {
  final ProfileRepository repository;

  UpdateMeAvatarUseCase(this.repository);

  Future<bool> call(String avatarUrl) {
    return repository.updateAvatar(avatarUrl);
  }
}
