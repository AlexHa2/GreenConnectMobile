import 'package:GreenConnectMobile/features/reward_item/domain/repositories/reward_item_repository.dart';

class DeleteRewardItemUsecase {
  final RewardItemRepository _repository;

  DeleteRewardItemUsecase(this._repository);

  Future<bool> call(int rewardItemId) async {
    return await _repository.deleteRewardItem(rewardItemId);
  }
}
