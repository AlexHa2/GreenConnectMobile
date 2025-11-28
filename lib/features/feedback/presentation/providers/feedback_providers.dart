import 'package:GreenConnectMobile/features/feedback/data/datasources/feedback_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/feedback/data/repository/feedback_repository_impl.dart';
import 'package:GreenConnectMobile/features/feedback/domain/repository/feedback_repository.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/create_feedback_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/delete_feedback_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/get_feedback_detail_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/get_my_feedbacks_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/update_feedback_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/viewmodels/feedback_view_model.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/viewmodels/states/feedback_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ==================
///  Remote DataSource
/// ==================
final feedbackRemoteDsProvider = Provider<FeedbackRemoteDataSourceImpl>((ref) {
  return FeedbackRemoteDataSourceImpl();
});

/// =============
///  Repository
/// =============
final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  final ds = ref.read(feedbackRemoteDsProvider);
  return FeedbackRepositoryImpl(ds);
});

/// =============
///  UseCases
/// =============

// Get my feedbacks
final getMyFeedbacksUsecaseProvider = Provider<GetMyFeedbacksUsecase>((ref) {
  return GetMyFeedbacksUsecase(ref.read(feedbackRepositoryProvider));
});

// Get feedback detail
final getFeedbackDetailUsecaseProvider =
    Provider<GetFeedbackDetailUsecase>((ref) {
  return GetFeedbackDetailUsecase(ref.read(feedbackRepositoryProvider));
});

// Create feedback
final createFeedbackUsecaseProvider = Provider<CreateFeedbackUsecase>((ref) {
  return CreateFeedbackUsecase(ref.read(feedbackRepositoryProvider));
});

// Update feedback
final updateFeedbackUsecaseProvider = Provider<UpdateFeedbackUsecase>((ref) {
  return UpdateFeedbackUsecase(ref.read(feedbackRepositoryProvider));
});

// Delete feedback
final deleteFeedbackUsecaseProvider = Provider<DeleteFeedbackUsecase>((ref) {
  return DeleteFeedbackUsecase(ref.read(feedbackRepositoryProvider));
});

/// =============
///  ViewModel
/// =============
final feedbackViewModelProvider =
    NotifierProvider<FeedbackViewModel, FeedbackState>(
  () => FeedbackViewModel(),
);
