import 'package:GreenConnectMobile/features/reward/data/datasources/reward_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/reward/data/repositories/reward_repository_impl.dart';
import 'package:GreenConnectMobile/features/reward/domain/repositories/reward_repository.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_reward_history_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_reward_items_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/redeem_reward_usecase.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/reward_viewmodel.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/states/reward_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ==================
///  Remote DataSource
/// ==================
final rewardRemoteDsProvider = Provider<RewardRemoteDataSourceImpl>((ref) {
  return RewardRemoteDataSourceImpl();
});

/// =============
///  Repository
/// =============
final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  final ds = ref.read(rewardRemoteDsProvider);
  return RewardRepositoryImpl(ds);
});

/// =============
///  UseCases
/// =============

// Get reward items
final getRewardItemsUsecaseProvider = Provider<GetRewardItemsUseCase>((ref) {
  return GetRewardItemsUseCase(ref.read(rewardRepositoryProvider));
});

// Get reward history
final getRewardHistoryUsecaseProvider = Provider<GetRewardHistoryUseCase>((
  ref,
) {
  return GetRewardHistoryUseCase(ref.read(rewardRepositoryProvider));
});

// Redeem reward
final redeemRewardUsecaseProvider = Provider<RedeemRewardUseCase>((ref) {
  return RedeemRewardUseCase(ref.read(rewardRepositoryProvider));
});

/// =============
///  ViewModel
/// =============
final rewardViewModelProvider = NotifierProvider<RewardViewModel, RewardState>(
  () => RewardViewModel(),
);
