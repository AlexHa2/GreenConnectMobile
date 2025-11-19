import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/repository/profile_repository.dart';

class GetMeUseCase {
  final ProfileRepository repository;

  GetMeUseCase(this.repository);

  Future<ProfileEntity> call() async {
    return repository.getMe();
  }
}
