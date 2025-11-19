import 'package:GreenConnectMobile/features/profile/domain/entities/verification_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/repository/profile_repository.dart';

class VerifyUserUseCase {
  final ProfileRepository repository;

  VerifyUserUseCase(this.repository);

  Future<String> call(VerificationEntity params) {
    return repository.verifyUser(params);
  }
}