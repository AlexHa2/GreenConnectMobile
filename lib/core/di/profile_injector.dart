import 'package:GreenConnectMobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:GreenConnectMobile/features/profile/data/repository/profile_repository_impl.dart';
import 'package:GreenConnectMobile/features/profile/domain/repository/profile_repository.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/update_me_usecase.dart';
import 'package:GreenConnectMobile/features/profile/domain/usecases/verify_user_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initAuthModule() async {
  // DataSources
  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasource(),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton<GetMeUseCase>(() => GetMeUseCase(sl()));
  sl.registerLazySingleton<UpdateMeUseCase>(() => UpdateMeUseCase(sl()));
  sl.registerLazySingleton<VerifyUserUseCase>(() => VerifyUserUseCase(sl()));
}
