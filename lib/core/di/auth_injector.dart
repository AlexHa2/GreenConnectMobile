import 'package:get_it/get_it.dart';
import 'package:GreenConnectMobile/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:GreenConnectMobile/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:GreenConnectMobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/get_user_usecase.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/login_usecase.dart';

final sl = GetIt.instance;

Future<void> initAuthModule() async {
  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(sl()));
}
