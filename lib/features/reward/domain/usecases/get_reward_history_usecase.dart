import 'package:GreenConnectMobile/features/reward/domain/entities/reward_history_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/repositories/reward_repository.dart';

class GetRewardHistoryUseCase {
  final RewardRepository repository;

  GetRewardHistoryUseCase(this.repository);

  Future<List<RewardHistoryEntity>> call() {
    return repository.getRewardHistory();
  }
}
