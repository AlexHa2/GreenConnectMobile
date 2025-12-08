import 'package:GreenConnectMobile/features/package/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/package/domain/repository/package_repository.dart';

class GetPackageByIdUseCase {
  final PackageRepository repository;

  GetPackageByIdUseCase(this.repository);

  Future<PackageEntity> call(String packageId) {
    return repository.getPackageById(packageId);
  }
}
