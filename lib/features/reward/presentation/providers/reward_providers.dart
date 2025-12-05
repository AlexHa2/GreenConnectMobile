import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/reward/data/datasources/reward_remote_datasource.dart';
import 'package:GreenConnectMobile/features/reward/data/datasources/reward_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/reward/data/repositories/reward_repository_impl.dart';
import 'package:GreenConnectMobile/features/reward/domain/repositories/reward_repository.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_package_by_id_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_packages_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_reward_history_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_reward_items_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/redeem_reward_usecase.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/package_viewmodel.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/reward_viewmodel.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/states/package_state.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/states/reward_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Sources
final rewardRemoteDataSourceProvider = Provider<RewardRemoteDataSource>((ref) {
  return RewardRemoteDataSourceImpl(sl<ApiClient>());
});

// Repositories
final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  final remoteDataSource = ref.read(rewardRemoteDataSourceProvider);
  return RewardRepositoryImpl(remoteDataSource);
});

// Use Cases - Packages
final getPackagesUseCaseProvider = Provider<GetPackagesUseCase>((ref) {
  final repository = ref.read(rewardRepositoryProvider);
  return GetPackagesUseCase(repository);
});

final getPackageByIdUseCaseProvider = Provider<GetPackageByIdUseCase>((ref) {
  final repository = ref.read(rewardRepositoryProvider);
  return GetPackageByIdUseCase(repository);
});

// Use Cases - Rewards
final getRewardItemsUseCaseProvider = Provider<GetRewardItemsUseCase>((ref) {
  final repository = ref.read(rewardRepositoryProvider);
  return GetRewardItemsUseCase(repository);
});

final getRewardHistoryUseCaseProvider = Provider<GetRewardHistoryUseCase>((ref) {
  final repository = ref.read(rewardRepositoryProvider);
  return GetRewardHistoryUseCase(repository);
});

final redeemRewardUseCaseProvider = Provider<RedeemRewardUseCase>((ref) {
  final repository = ref.read(rewardRepositoryProvider);
  return RedeemRewardUseCase(repository);
});

// ViewModels
final packageViewModelProvider = NotifierProvider<PackageViewModel, PackageState>(() {
  throw UnimplementedError();
});

final rewardViewModelProvider = NotifierProvider<RewardViewModel, RewardState>(() {
  throw UnimplementedError();
});

// ViewModel Providers with Dependencies
final packageViewModelImplProvider = Provider<PackageViewModel>((ref) {
  return PackageViewModel(
    getPackagesUseCase: ref.read(getPackagesUseCaseProvider),
    getPackageByIdUseCase: ref.read(getPackageByIdUseCaseProvider),
  );
});

final rewardViewModelImplProvider = Provider<RewardViewModel>((ref) {
  return RewardViewModel(
    getRewardItemsUseCase: ref.read(getRewardItemsUseCaseProvider),
    getRewardHistoryUseCase: ref.read(getRewardHistoryUseCaseProvider),
    redeemRewardUseCase: ref.read(redeemRewardUseCaseProvider),
  );
});
