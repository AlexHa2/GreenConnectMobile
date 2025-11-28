import 'package:GreenConnectMobile/features/feedback/domain/entities/create_feedback_request.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_entity.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_list_response.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/update_feedback_request.dart';

abstract class FeedbackRepository {
  Future<FeedbackListResponse> getMyFeedbacks({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatAt,
  });

  Future<FeedbackEntity> getFeedbackDetail(String feedbackId);

  Future<FeedbackEntity> createFeedback(CreateFeedbackRequest request);

  Future<FeedbackEntity> updateFeedback({
    required String feedbackId,
    required UpdateFeedbackRequest request,
  });

  Future<bool> deleteFeedback(String feedbackId);
}
