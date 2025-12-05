import 'package:GreenConnectMobile/features/reward/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/paginated_packages_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/reward_history_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/reward_item_entity.dart';

abstract class RewardRepository {
  /// Get packages with pagination and filters
  Future<PaginatedPackagesEntity> getPackages({
    required int pageNumber,
    required int pageSize,
    bool? sortByPrice,
    String? packageType,
    String? name,
  });

  /// Get package detail by ID
  Future<PackageEntity> getPackageById(String packageId);

  /// Get all reward items
  Future<List<RewardItemEntity>> getRewardItems();

  /// Get reward redemption history
  Future<List<RewardHistoryEntity>> getRewardHistory();

  /// Redeem a reward item
  Future<bool> redeemReward(int rewardItemId);
}
