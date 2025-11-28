import 'package:GreenConnectMobile/features/feedback/data/datasources/feedback_remote_datasource.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/create_feedback_request.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_entity.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_list_response.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/update_feedback_request.dart';
import 'package:GreenConnectMobile/features/feedback/domain/repository/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource _remoteDataSource;

  FeedbackRepositoryImpl(this._remoteDataSource);

  @override
  Future<FeedbackListResponse> getMyFeedbacks({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatAt,
  }) async {
    final result = await _remoteDataSource.getMyFeedbacks(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortByCreatAt: sortByCreatAt,
    );
    return result.toEntity();
  }

  @override
  Future<FeedbackEntity> getFeedbackDetail(String feedbackId) async {
    final result = await _remoteDataSource.getFeedbackDetail(feedbackId);
    return result.toEntity();
  }

  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackRequest request) async {
    final result = await _remoteDataSource.createFeedback(request);
    return result.toEntity();
  }

  @override
  Future<FeedbackEntity> updateFeedback({
    required String feedbackId,
    required UpdateFeedbackRequest request,
  }) async {
    final result = await _remoteDataSource.updateFeedback(
      feedbackId: feedbackId,
      request: request,
    );
    return result.toEntity();
  }

  @override
  Future<bool> deleteFeedback(String feedbackId) async {
    return await _remoteDataSource.deleteFeedback(feedbackId);
  }
}
