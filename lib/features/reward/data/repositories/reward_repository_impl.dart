import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/reward/data/datasources/reward_remote_datasource.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/paginated_packages_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/reward_history_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/reward_item_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/repositories/reward_repository.dart';

class RewardRepositoryImpl implements RewardRepository {
  final RewardRemoteDataSource remoteDataSource;

  RewardRepositoryImpl(this.remoteDataSource);

  @override
  Future<PaginatedPackagesEntity> getPackages({
    required int pageNumber,
    required int pageSize,
    bool? sortByPrice,
    String? packageType,
    String? name,
  }) async {
    return guard(() async {
      final result = await remoteDataSource.getPackages(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortByPrice: sortByPrice,
        packageType: packageType,
        name: name,
      );
      return result.toEntity();
    });
  }

  @override
  Future<PackageEntity> getPackageById(String packageId) async {
    return guard(() async {
      final result = await remoteDataSource.getPackageById(packageId);
      return result.toEntity();
    });
  }

  @override
  Future<List<RewardItemEntity>> getRewardItems() async {
    return guard(() async {
      final results = await remoteDataSource.getRewardItems();
      return results.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<List<RewardHistoryEntity>> getRewardHistory() async {
    return guard(() async {
      final results = await remoteDataSource.getRewardHistory();
      return results.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<bool> redeemReward(int rewardItemId) async {
    return guard(() async {
      return await remoteDataSource.redeemReward(rewardItemId);
    });
  }
}
