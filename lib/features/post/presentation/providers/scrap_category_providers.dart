import 'package:GreenConnectMobile/features/post/data/datasources/scrap_category_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/repository/scrap_category_repository_impl.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_category_repository.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_scrap_categories_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_scrap_category_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/presentation/viewmodels/scrap_category_viewmodel.dart';
import 'package:GreenConnectMobile/features/post/presentation/viewmodels/states/scrap_category_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Remote DataSource Provider
final scrapCategoryRemoteDsProvider = Provider<ScrapCategoryRemoteDataSourceImpl>((
  ref,
) {
  return ScrapCategoryRemoteDataSourceImpl();
});

// Repository Provider
final scrapCategoryRepositoryProvider = Provider<ScrapCategoryRepository>((
  ref,
) {
  final ds = ref.read(scrapCategoryRemoteDsProvider);
  return ScrapCategoryRepositoryImpl(remoteDataSource: ds);
});

// UseCases Provider
final getScrapCategoriesUsecaseProvider = Provider<GetScrapCategoriesUseCase>((
  ref,
) {
  return GetScrapCategoriesUseCase(
    repository: ref.read(scrapCategoryRepositoryProvider),
  );
});

final getScrapCategoryDetailUsecaseProvider =
    Provider<GetScrapCategoryDetailUseCase>((ref) {
      return GetScrapCategoryDetailUseCase(
        repository: ref.read(scrapCategoryRepositoryProvider),
      );
    });

// Viewmodel Provider
final scrapCategoryViewModelProvider =
    NotifierProvider<ScrapCategoryViewModel, ScrapCategoryState>(
      () => ScrapCategoryViewModel(),
    );
