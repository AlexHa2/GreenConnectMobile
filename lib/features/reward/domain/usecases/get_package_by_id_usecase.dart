import 'package:GreenConnectMobile/features/reward/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/repositories/reward_repository.dart';

class GetPackageByIdUseCase {
  final RewardRepository repository;

  GetPackageByIdUseCase(this.repository);

  Future<PackageEntity> call(String packageId) {
    return repository.getPackageById(packageId);
  }
}
