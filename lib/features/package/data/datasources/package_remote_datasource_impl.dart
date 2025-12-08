import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/package/data/datasources/package_remote_datasource.dart';
import 'package:GreenConnectMobile/features/package/data/models/package_list_response_model.dart';
import 'package:GreenConnectMobile/features/package/data/models/package_model.dart';

class PackageRemoteDataSourceImpl implements PackageRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String _baseUrl = '/v1/packages';

  @override
  Future<PackageListResponseModel> getPackages({
    int pageNumber = 1,
    int pageSize = 10,
    bool? sortByPrice,
    String? packageType,
  }) async {
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    if (sortByPrice != null) {
      queryParameters['sortByPrice'] = sortByPrice;
    }

    if (packageType != null && packageType.isNotEmpty) {
      queryParameters['packageType'] = packageType;
    }

    final response = await _apiClient.get(
      _baseUrl,
      queryParameters: queryParameters,
    );

    return PackageListResponseModel.fromJson(response.data);
  }

  @override
  Future<PackageModel> getPackageById(String packageId) async {
    final response = await _apiClient.get('$_baseUrl/$packageId');
    return PackageModel.fromJson(response.data);
  }
}
