import 'package:GreenConnectMobile/features/post/data/datasources/abstract_datasources/scrap_category_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/datasources/scrap_category_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/repository/scrap_category_repository_impl.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_category_repository.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_scrap_categories_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_scrap_category_detail_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initScrapCategoryModule() async {
  // DataSources
  sl.registerLazySingleton<ScrapCategoryRemoteDataSource>(
    () => ScrapCategoryRemoteDataSourceImpl(),
  );
  // Repository
  sl.registerLazySingleton<ScrapCategoryRepository>(
    () => ScrapCategoryRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetScrapCategoriesUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => GetScrapCategoryDetailUseCase(repository: sl()),
  );
}
