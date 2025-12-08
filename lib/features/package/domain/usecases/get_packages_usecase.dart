import 'package:GreenConnectMobile/features/package/domain/entities/package_list_response_entity.dart';
import 'package:GreenConnectMobile/features/package/domain/repository/package_repository.dart';

class GetPackagesUseCase {
  final PackageRepository repository;

  GetPackagesUseCase(this.repository);

  Future<PackageListResponseEntity> call({
    int pageNumber = 1,
    int pageSize = 10,
    bool? sortByPrice,
    String? packageType,
  }) {
    return repository.getPackages(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortByPrice: sortByPrice,
      packageType: packageType,
    );
  }
}
