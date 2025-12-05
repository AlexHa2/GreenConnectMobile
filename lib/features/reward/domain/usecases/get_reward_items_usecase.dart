import 'package:GreenConnectMobile/features/reward/domain/entities/reward_item_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/repositories/reward_repository.dart';

class GetRewardItemsUseCase {
  final RewardRepository repository;

  GetRewardItemsUseCase(this.repository);

  Future<List<RewardItemEntity>> call() {
    return repository.getRewardItems();
  }
}
