import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/package/data/datasources/package_remote_datasource.dart';
import 'package:GreenConnectMobile/features/package/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/package/domain/entities/package_list_response_entity.dart';
import 'package:GreenConnectMobile/features/package/domain/repository/package_repository.dart';

class PackageRepositoryImpl implements PackageRepository {
  final PackageRemoteDataSource _remoteDataSource;

  PackageRepositoryImpl(this._remoteDataSource);

  @override
  Future<PackageListResponseEntity> getPackages({
    int pageNumber = 1,
    int pageSize = 10,
    bool? sortByPrice,
    String? packageType,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.getPackages(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortByPrice: sortByPrice,
        packageType: packageType,
      );
      return response.toEntity();
    });
  }

  @override
  Future<PackageEntity> getPackageById(String packageId) {
    return guard(() async {
      final response = await _remoteDataSource.getPackageById(packageId);
      return response.toEntity();
    });
  }
}
