import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_entity.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/update_feedback_request.dart';
import 'package:GreenConnectMobile/features/feedback/domain/repository/feedback_repository.dart';

class UpdateFeedbackUsecase {
  final FeedbackRepository _repository;

  UpdateFeedbackUsecase(this._repository);

  Future<FeedbackEntity> call({
    required String feedbackId,
    required UpdateFeedbackRequest request,
  }) async {
    return await _repository.updateFeedback(
      feedbackId: feedbackId,
      request: request,
    );
  }
}
