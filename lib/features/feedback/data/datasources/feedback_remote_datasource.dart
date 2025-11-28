import 'package:GreenConnectMobile/features/feedback/data/models/feedback_list_response_model.dart';
import 'package:GreenConnectMobile/features/feedback/data/models/feedback_model.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/create_feedback_request.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/update_feedback_request.dart';

abstract class FeedbackRemoteDataSource {
  /// GET /v1/feedbacks/my-feedbacks
  Future<FeedbackListResponseModel> getMyFeedbacks({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatAt,
  });

  /// GET /v1/feedbacks/{id}
  Future<FeedbackModel> getFeedbackDetail(String feedbackId);

  /// POST /v1/feedbacks
  Future<FeedbackModel> createFeedback(CreateFeedbackRequest request);

  /// PATCH /v1/feedbacks/{id}
  Future<FeedbackModel> updateFeedback({
    required String feedbackId,
    required UpdateFeedbackRequest request,
  });

  /// DELETE /v1/feedbacks/{id}
  Future<bool> deleteFeedback(String feedbackId);
}
