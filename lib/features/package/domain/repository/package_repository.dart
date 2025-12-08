import 'package:GreenConnectMobile/features/package/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/package/domain/entities/package_list_response_entity.dart';

abstract class PackageRepository {
  Future<PackageListResponseEntity> getPackages({
    int pageNumber = 1,
    int pageSize = 10,
    bool? sortByPrice,
    String? packageType, // "Freemium" or "Paid"
  });

  Future<PackageEntity> getPackageById(String packageId);
}
