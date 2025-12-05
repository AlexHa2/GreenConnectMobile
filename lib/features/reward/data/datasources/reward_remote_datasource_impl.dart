import 'package:GreenConnectMobile/core/helper/query_helper.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/reward/data/datasources/reward_remote_datasource.dart';
import 'package:GreenConnectMobile/features/reward/data/models/package_model.dart';
import 'package:GreenConnectMobile/features/reward/data/models/paginated_packages_model.dart';
import 'package:GreenConnectMobile/features/reward/data/models/reward_history_model.dart';
import 'package:GreenConnectMobile/features/reward/data/models/reward_item_model.dart';

class RewardRemoteDataSourceImpl implements RewardRemoteDataSource {
  final ApiClient apiClient;

  static const String _packagesUrl = '/v1/packages';
  static const String _rewardsUrl = '/v1/rewards';
  static const String _rewardHistoryUrl = '/v1/rewards/my-history';

  RewardRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PaginatedPackagesModel> getPackages({
    required int pageNumber,
    required int pageSize,
    bool? sortByPrice,
    String? packageType,
    String? name,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'sortByPrice': sortByPrice,
      'packageType': packageType,
      'name': name,
    };

    final url = withQuery(_packagesUrl, queryParams);
    final response = await apiClient.get(url);

    return PaginatedPackagesModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<PackageModel> getPackageById(String packageId) async {
    final response = await apiClient.get('$_packagesUrl/$packageId');
    return PackageModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<RewardItemModel>> getRewardItems() async {
    final response = await apiClient.get(_rewardsUrl);

    if (response.data is List) {
      return (response.data as List)
          .map((item) => RewardItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  @override
  Future<List<RewardHistoryModel>> getRewardHistory() async {
    final response = await apiClient.get(_rewardHistoryUrl);

    if (response.data is List) {
      return (response.data as List)
          .map(
            (item) => RewardHistoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }

    return [];
  }

  @override
  Future<bool> redeemReward(int rewardItemId) async {
    try {
      await apiClient.post('$_rewardsUrl/$rewardItemId/redeem');
      return true;
    } catch (e) {
      return false;
    }
  }
}
