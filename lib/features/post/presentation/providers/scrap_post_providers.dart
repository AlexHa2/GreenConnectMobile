import 'package:GreenConnectMobile/features/post/data/datasources/scrap_post_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/repository/scrap_post_repository_impl.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/analyze_scrap_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/create_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/create_time_slot_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/delete_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/delete_time_slot_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_household_report_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_my_scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_post_transactions_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_scrap_post_detail_usecases.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/search_posts_for_collector_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/toggle_scrap_post_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/update_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/update_scrap_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/update_time_slot_usecase.dart';
import 'package:GreenConnectMobile/features/post/presentation/viewmodels/scrap_post_view_model.dart';
import 'package:GreenConnectMobile/features/post/presentation/viewmodels/states/scrap_post_state.dart';
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

// Analyze scrap
final analyzeScrapUsecaseProvider = Provider<AnalyzeScrapUsecase>((ref) {
  return AnalyzeScrapUsecase(ref.read(scrapPostRepositoryProvider));
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

// Search posts for collector
final searchPostsForCollectorUsecaseProvider =
    Provider<SearchPostsForCollectorUsecase>((ref) {
  return SearchPostsForCollectorUsecase(ref.read(scrapPostRepositoryProvider));
});

// Get household report
final getHouseholdReportUsecaseProvider =
    Provider<GetHouseholdReportUsecase>((ref) {
  return GetHouseholdReportUsecase(ref.read(scrapPostRepositoryProvider));
});

// Get post transactions
final getPostTransactionsUsecaseProvider =
    Provider<GetPostTransactionsUsecase>((ref) {
  return GetPostTransactionsUsecase(ref.read(scrapPostRepositoryProvider));
});

// Create time slot
final createTimeSlotUsecaseProvider = Provider<CreateTimeSlotUsecase>((ref) {
  return CreateTimeSlotUsecase(ref.read(scrapPostRepositoryProvider));
});

// Update time slot
final updateTimeSlotUsecaseProvider = Provider<UpdateTimeSlotUsecase>((ref) {
  return UpdateTimeSlotUsecase(ref.read(scrapPostRepositoryProvider));
});

// Delete time slot
final deleteTimeSlotUsecaseProvider = Provider<DeleteTimeSlotUsecase>((ref) {
  return DeleteTimeSlotUsecase(ref.read(scrapPostRepositoryProvider));
});

final scrapPostViewModelProvider =
    NotifierProvider<ScrapPostViewModel, ScrapPostState>(
      () => ScrapPostViewModel(),
    );
