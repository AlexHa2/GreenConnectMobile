import 'package:GreenConnectMobile/features/reward_item/data/datasources/reward_item_remote_datasource.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/create_reward_item_request.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_entity.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_list_response.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/update_reward_item_request.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/repositories/reward_item_repository.dart';

class RewardItemRepositoryImpl implements RewardItemRepository {
  final RewardItemRemoteDatasource _remoteDatasource;

  RewardItemRepositoryImpl(this._remoteDatasource);

  @override
  Future<RewardItemListResponse> getAllRewardItems({
    int? pageIndex,
    int? pageSize,
    String? name,
    bool? sortByPoint,
  }) async {
    final model = await _remoteDatasource.getAllRewardItems(
      pageIndex: pageIndex,
      pageSize: pageSize,
      name: name,
      sortByPoint: sortByPoint,
    );
    return model.toEntity();
  }

  @override
  Future<RewardItemEntity> getRewardItemDetail(int rewardItemId) async {
    final model = await _remoteDatasource.getRewardItemDetail(rewardItemId);
    return model.toEntity();
  }

  @override
  Future<bool> createRewardItem(CreateRewardItemRequest request) async {
    return await _remoteDatasource.createRewardItem(request);
  }

  @override
  Future<RewardItemEntity> updateRewardItem({
    required int rewardItemId,
    required UpdateRewardItemRequest request,
  }) async {
    final model = await _remoteDatasource.updateRewardItem(
      rewardItemId: rewardItemId,
      request: request,
    );
    return model.toEntity();
  }

  @override
  Future<bool> deleteRewardItem(int rewardItemId) async {
    return await _remoteDatasource.deleteRewardItem(rewardItemId);
  }
}
