import 'package:GreenConnectMobile/features/reward_item/data/datasources/reward_item_remote_datasource.dart';
import 'package:GreenConnectMobile/features/reward_item/data/datasources/reward_item_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/reward_item/data/repositories/reward_item_repository_impl.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/repositories/reward_item_repository.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/create_reward_item_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/delete_reward_item_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/get_all_reward_items_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/get_reward_item_detail_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/update_reward_item_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/presentation/state/reward_item_state.dart';
import 'package:GreenConnectMobile/features/reward_item/presentation/viewmodel/reward_item_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Datasource Provider
final rewardItemRemoteDsProvider = Provider<RewardItemRemoteDatasource>((ref) {
  return RewardItemRemoteDatasourceImpl();
});

// Repository Provider
final rewardItemRepositoryProvider = Provider<RewardItemRepository>((ref) {
  final remoteDatasource = ref.read(rewardItemRemoteDsProvider);
  return RewardItemRepositoryImpl(remoteDatasource);
});

// Use Case Providers
final getAllRewardItemsUsecaseProvider =
    Provider<GetAllRewardItemsUsecase>((ref) {
  final repository = ref.read(rewardItemRepositoryProvider);
  return GetAllRewardItemsUsecase(repository);
});

final getRewardItemDetailUsecaseProvider =
    Provider<GetRewardItemDetailUsecase>((ref) {
  final repository = ref.read(rewardItemRepositoryProvider);
  return GetRewardItemDetailUsecase(repository);
});

final createRewardItemUsecaseProvider =
    Provider<CreateRewardItemUsecase>((ref) {
  final repository = ref.read(rewardItemRepositoryProvider);
  return CreateRewardItemUsecase(repository);
});

final updateRewardItemUsecaseProvider =
    Provider<UpdateRewardItemUsecase>((ref) {
  final repository = ref.read(rewardItemRepositoryProvider);
  return UpdateRewardItemUsecase(repository);
});

final deleteRewardItemUsecaseProvider =
    Provider<DeleteRewardItemUsecase>((ref) {
  final repository = ref.read(rewardItemRepositoryProvider);
  return DeleteRewardItemUsecase(repository);
});

// ViewModel Provider
final rewardItemViewModelProvider =
    NotifierProvider<RewardItemViewModel, RewardItemState>(() {
  return RewardItemViewModel();
});