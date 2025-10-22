
import 'package:GreenConnectMobile/features/setting/data/repository/settings_repository_impl.dart';
import 'package:GreenConnectMobile/features/setting/domain/repository/settings_repository.dart';
import 'package:GreenConnectMobile/features/setting/domain/usecases/get_settings_usecase.dart';
import 'package:GreenConnectMobile/features/setting/domain/usecases/update_settings_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initSettingsModule() async {
  // Repository
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSettingsUseCase(sl()));

}
