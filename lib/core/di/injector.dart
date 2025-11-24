import 'package:GreenConnectMobile/core/di/auth_injector.dart';
import 'package:GreenConnectMobile/core/di/scrap_category_injector.dart';
import 'package:GreenConnectMobile/core/di/setting_injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => TokenStorageService());
  sl.registerLazySingleton(() => ApiClient(sl<TokenStorageService>()));

  // Modules
  await initAuthModule();
  await initSettingsModule();
  await initScrapCategoryModule();
}
