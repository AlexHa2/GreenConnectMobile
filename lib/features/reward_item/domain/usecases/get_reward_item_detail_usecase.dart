import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_entity.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/repositories/reward_item_repository.dart';

class GetRewardItemDetailUsecase {
  final RewardItemRepository _repository;

  GetRewardItemDetailUsecase(this._repository);

  Future<RewardItemEntity> call(int rewardItemId) async {
    return await _repository.getRewardItemDetail(rewardItemId);
  }
}
