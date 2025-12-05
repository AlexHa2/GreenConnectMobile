import 'package:GreenConnectMobile/features/reward/domain/entities/paginated_packages_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/repositories/reward_repository.dart';

class GetPackagesUseCase {
  final RewardRepository repository;

  GetPackagesUseCase(this.repository);

  Future<PaginatedPackagesEntity> call({
    required int pageNumber,
    required int pageSize,
    bool? sortByPrice,
    String? packageType,
    String? name,
  }) {
    return repository.getPackages(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortByPrice: sortByPrice,
      packageType: packageType,
      name: name,
    );
  }
}
