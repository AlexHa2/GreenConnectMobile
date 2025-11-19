import 'package:GreenConnectMobile/features/profile/data/models/user_update_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/repository/profile_repository.dart';

class UpdateMeUseCase {
  final ProfileRepository repository;

  UpdateMeUseCase(this.repository);

  Future<ProfileEntity> call(UserUpdateModel updateModel) {
    return repository.updateMe(updateModel);
  }
}
