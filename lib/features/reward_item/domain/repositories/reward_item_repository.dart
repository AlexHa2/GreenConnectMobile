import 'package:GreenConnectMobile/features/reward_item/domain/entities/create_reward_item_request.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_entity.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_list_response.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/update_reward_item_request.dart';

abstract class RewardItemRepository {
  Future<RewardItemListResponse> getAllRewardItems({
    int? pageIndex,
    int? pageSize,
    String? name,
    bool? sortByPoint,
  });

  Future<RewardItemEntity> getRewardItemDetail(int rewardItemId);

  Future<bool> createRewardItem(CreateRewardItemRequest request);

  Future<RewardItemEntity> updateRewardItem({
    required int rewardItemId,
    required UpdateRewardItemRequest request,
  });

  Future<bool> deleteRewardItem(int rewardItemId);
}
