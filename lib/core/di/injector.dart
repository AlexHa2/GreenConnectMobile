
import 'package:get_it/get_it.dart';
import 'package:green_connect_mb/core/network/api_client.dart';
import 'package:green_connect_mb/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:green_connect_mb/features/auth/data/repository/auth_repository_impl.dart';
import 'package:green_connect_mb/features/auth/domain/repository/auth_repository.dart';
import 'package:green_connect_mb/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:green_connect_mb/features/auth/domain/usecases/login_usecase.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(sl()));
}
