import 'package:GreenConnectMobile/features/reward_item/domain/entities/create_reward_item_request.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/repositories/reward_item_repository.dart';

class CreateRewardItemUsecase {
  final RewardItemRepository _repository;

  CreateRewardItemUsecase(this._repository);

  Future<bool> call(CreateRewardItemRequest request) async {
    return await _repository.createRewardItem(request);
  }
}
