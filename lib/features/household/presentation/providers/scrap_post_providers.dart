import 'package:GreenConnectMobile/features/household/data/datasources/scrap_post_remote_datasource.dart';
import 'package:GreenConnectMobile/features/household/data/repository/scrap_post_repository_impl.dart';
import 'package:GreenConnectMobile/features/household/domain/repository/scrap_post_repository.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/create_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/delete_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/get_my_scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/get_scrap_post_detail_usecases.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/toggle_scrap_post_usecase.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/update_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/update_scrap_usecase.dart';
import 'package:GreenConnectMobile/features/household/presentation/viewmodels/scrap_post_view_model.dart';
import 'package:GreenConnectMobile/features/household/presentation/viewmodels/states/scrap_post_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ==================
///  Remote DataSource
/// ==================
final scrapPostRemoteDsProvider = Provider<ScrapPostRemoteDataSourceImpl>((
  ref,
) {
  return ScrapPostRemoteDataSourceImpl();
});

/// =============
///  Repository
/// =============
final scrapPostRepositoryProvider = Provider<ScrapPostRepository>((ref) {
  final ds = ref.read(scrapPostRemoteDsProvider);
  return ScrapPostRepositoryImpl(ds);
});

/// =============
///  UseCases
/// =============

// Create post
final createScrapPostUsecaseProvider = Provider<CreateScrapPostUsecase>((ref) {
  return CreateScrapPostUsecase(ref.read(scrapPostRepositoryProvider));
});

// Get my posts
final getMyScrapPostsUsecaseProvider = Provider<GetMyScrapPostsUsecase>((ref) {
  return GetMyScrapPostsUsecase(ref.read(scrapPostRepositoryProvider));
});

// Get post detail
final getScrapPostDetailUsecaseProvider = Provider<GetScrapPostDetailUsecase>((
  ref,
) {
  return GetScrapPostDetailUsecase(ref.read(scrapPostRepositoryProvider));
});

// Update post
final updateScrapPostUsecaseProvider = Provider<UpdateScrapPostUsecase>((ref) {
  return UpdateScrapPostUsecase(ref.read(scrapPostRepositoryProvider));
});

// Toggle post
final toggleScrapPostUsecaseProvider = Provider<ToggleScrapPostUsecase>((ref) {
  return ToggleScrapPostUsecase(ref.read(scrapPostRepositoryProvider));
});

// Create detail
final createScrapDetailUsecaseProvider = Provider<CreateScrapDetailUsecase>((
  ref,
) {
  return CreateScrapDetailUsecase(ref.read(scrapPostRepositoryProvider));
});

// Update detail
final updateScrapDetailUsecaseProvider = Provider<UpdateScrapDetailUsecase>((
  ref,
) {
  return UpdateScrapDetailUsecase(ref.read(scrapPostRepositoryProvider));
});

// Delete detail
final deleteScrapDetailUsecaseProvider = Provider<DeleteScrapDetailUsecase>((
  ref,
) {
  return DeleteScrapDetailUsecase(ref.read(scrapPostRepositoryProvider));
});

final scrapPostViewModelProvider =
    NotifierProvider<ScrapPostViewModel, ScrapPostState>(
      () => ScrapPostViewModel(),
    );
