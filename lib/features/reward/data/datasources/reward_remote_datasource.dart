import 'package:GreenConnectMobile/features/reward/data/models/package_model.dart';
import 'package:GreenConnectMobile/features/reward/data/models/paginated_packages_model.dart';
import 'package:GreenConnectMobile/features/reward/data/models/reward_history_model.dart';
import 'package:GreenConnectMobile/features/reward/data/models/reward_item_model.dart';

abstract class RewardRemoteDataSource {
  Future<PaginatedPackagesModel> getPackages({
    required int pageNumber,
    required int pageSize,
    bool? sortByPrice,
    String? packageType,
    String? name,
  });

  Future<PackageModel> getPackageById(String packageId);

  Future<List<RewardItemModel>> getRewardItems();

  Future<List<RewardHistoryModel>> getRewardHistory();

  Future<bool> redeemReward(int rewardItemId);
}
