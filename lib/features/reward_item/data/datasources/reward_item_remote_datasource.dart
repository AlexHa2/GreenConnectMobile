import 'package:GreenConnectMobile/features/reward_item/data/models/reward_item_list_response_model.dart';
import 'package:GreenConnectMobile/features/reward_item/data/models/reward_item_model.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/create_reward_item_request.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/update_reward_item_request.dart';

abstract class RewardItemRemoteDatasource {
  /// GET /v1/reward-items?pageIndex={page}&pageSize={size}&name={name}&sortByPoint={bool}
  Future<RewardItemListResponseModel> getAllRewardItems({
    int? pageIndex,
    int? pageSize,
    String? name,
    bool? sortByPoint,
  });

  /// GET /v1/reward-items/{id}
  Future<RewardItemModel> getRewardItemDetail(int rewardItemId);

  /// POST /v1/reward-items
  Future<bool> createRewardItem(CreateRewardItemRequest request);

  /// PATCH /v1/reward-items/{id}
  Future<RewardItemModel> updateRewardItem({
    required int rewardItemId,
    required UpdateRewardItemRequest request,
  });

  /// DELETE /v1/reward-items/{id}
  Future<bool> deleteRewardItem(int rewardItemId);
}
