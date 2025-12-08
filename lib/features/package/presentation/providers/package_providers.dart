import 'package:GreenConnectMobile/features/package/data/datasources/package_remote_datasource.dart';
import 'package:GreenConnectMobile/features/package/data/datasources/package_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/package/data/repository/package_repository_impl.dart';
import 'package:GreenConnectMobile/features/package/domain/repository/package_repository.dart';
import 'package:GreenConnectMobile/features/package/domain/usecases/get_package_by_id_usecase.dart';
import 'package:GreenConnectMobile/features/package/domain/usecases/get_packages_usecase.dart';
import 'package:GreenConnectMobile/features/package/presentation/viewmodels/package_viewmodel.dart';
import 'package:GreenConnectMobile/features/package/presentation/viewmodels/states/package_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Source Provider
final packageRemoteDataSourceProvider = Provider<PackageRemoteDataSource>((ref) {
  return PackageRemoteDataSourceImpl();
});

// Repository Provider
final packageRepositoryProvider = Provider<PackageRepository>((ref) {
  final remoteDataSource = ref.read(packageRemoteDataSourceProvider);
  return PackageRepositoryImpl(remoteDataSource);
});

// UseCase Providers
final getPackagesUseCaseProvider = Provider<GetPackagesUseCase>((ref) {
  final repository = ref.read(packageRepositoryProvider);
  return GetPackagesUseCase(repository);
});

final getPackageByIdUseCaseProvider = Provider<GetPackageByIdUseCase>((ref) {
  final repository = ref.read(packageRepositoryProvider);
  return GetPackageByIdUseCase(repository);
});

// ViewModel Provider
final packageViewModelProvider =
    NotifierProvider<PackageViewModel, PackageState>(() => PackageViewModel());
