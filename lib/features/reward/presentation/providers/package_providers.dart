import 'package:GreenConnectMobile/features/reward/data/datasources/reward_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/reward/data/repositories/reward_repository_impl.dart';
import 'package:GreenConnectMobile/features/reward/domain/repositories/reward_repository.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_package_by_id_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_packages_usecase.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/package_viewmodel.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/states/package_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ==================
///  Remote DataSource
/// ==================
final packageRemoteDsProvider = Provider<RewardRemoteDataSourceImpl>((ref) {
  return RewardRemoteDataSourceImpl();
});

/// =============
///  Repository
/// =============
final packageRepositoryProvider = Provider<RewardRepository>((ref) {
  final ds = ref.read(packageRemoteDsProvider);
  return RewardRepositoryImpl(ds);
});

/// =============
///  UseCases
/// =============

// Get packages
final getPackagesUsecaseProvider = Provider<GetPackagesUseCase>((ref) {
  return GetPackagesUseCase(ref.read(packageRepositoryProvider));
});

// Get package by id
final getPackageByIdUsecaseProvider = Provider<GetPackageByIdUseCase>((ref) {
  return GetPackageByIdUseCase(ref.read(packageRepositoryProvider));
});

/// =============
///  ViewModel
/// =============
final packageViewModelProvider =
    NotifierProvider<PackageViewModel, PackageState>(() => PackageViewModel());
