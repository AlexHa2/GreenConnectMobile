import 'package:GreenConnectMobile/features/profile/domain/entities/verification_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/repository/profile_repository.dart';

class UpdateVerificationUsecase {
  final ProfileRepository repository;

  UpdateVerificationUsecase(this.repository);

  Future<String> call(VerificationEntity verify) {
    return repository.updateVerification(verify);
  }
}
