import 'package:GreenConnectMobile/features/post/data/datasources/abstract_datasources/scrap_post_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/datasources/scrap_post_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/repository/scrap_post_repository_impl.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/create_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/delete_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_my_scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_scrap_post_detail_usecases.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/toggle_scrap_post_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/update_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/update_scrap_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initScrapPostModule() async {
  // Repository DataSources
  sl.registerLazySingleton<ScrapPostRemoteDataSource>(
    () => ScrapPostRemoteDataSourceImpl(),
  );
  // Repository
  sl.registerLazySingleton<ScrapPostRepository>(
    () => ScrapPostRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => CreateScrapDetailUsecase(sl()));
  sl.registerLazySingleton(() => CreateScrapPostUsecase(sl()));
  sl.registerLazySingleton(() => GetMyScrapPostsUsecase(sl()));
  sl.registerLazySingleton(() => GetScrapPostDetailUsecase(sl()));
  sl.registerLazySingleton(() => UpdateScrapPostUsecase(sl()));
  sl.registerLazySingleton(() => UpdateScrapDetailUsecase(sl()));
  sl.registerLazySingleton(() => ToggleScrapPostUsecase(sl()));
  sl.registerLazySingleton(() => DeleteScrapDetailUsecase(sl()));
}
