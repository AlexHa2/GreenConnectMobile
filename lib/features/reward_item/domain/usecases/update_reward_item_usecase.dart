import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_entity.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/update_reward_item_request.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/repositories/reward_item_repository.dart';

class UpdateRewardItemUsecase {
  final RewardItemRepository _repository;

  UpdateRewardItemUsecase(this._repository);

  Future<RewardItemEntity> call({
    required int rewardItemId,
    required UpdateRewardItemRequest request,
  }) async {
    return await _repository.updateRewardItem(
      rewardItemId: rewardItemId,
      request: request,
    );
  }
}
