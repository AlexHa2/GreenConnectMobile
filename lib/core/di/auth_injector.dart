import 'package:GreenConnectMobile/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:GreenConnectMobile/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:GreenConnectMobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/login_system_usecase.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:GreenConnectMobile/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initAuthModule() async {
  // DataSources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(firebaseAuth: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authDatasource: sl()),
  );

  // UseCases
  sl.registerLazySingleton<LoginSystemUsecase>(
    () => LoginSystemUsecase(repository: sl()),
  );
  sl.registerLazySingleton<SendOtpUsecase>(
    () => SendOtpUsecase(repository: sl()),
  );
  sl.registerLazySingleton<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(repository: sl()),
  );
}
