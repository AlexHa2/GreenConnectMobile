import 'package:GreenConnectMobile/features/package/data/models/package_list_response_model.dart';
import 'package:GreenConnectMobile/features/package/data/models/package_model.dart';

abstract class PackageRemoteDataSource {
  Future<PackageListResponseModel> getPackages({
    int pageNumber = 1,
    int pageSize = 10,
    bool? sortByPrice,
    String? packageType,
  });

  Future<PackageModel> getPackageById(String packageId);
}
