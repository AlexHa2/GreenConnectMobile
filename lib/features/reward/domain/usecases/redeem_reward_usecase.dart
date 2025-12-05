import 'package:GreenConnectMobile/features/reward/domain/repositories/reward_repository.dart';

class RedeemRewardUseCase {
  final RewardRepository repository;

  RedeemRewardUseCase(this.repository);

  Future<bool> call(int rewardItemId) {
    return repository.redeemReward(rewardItemId);
  }
}
