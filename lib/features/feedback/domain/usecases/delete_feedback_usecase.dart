import 'package:GreenConnectMobile/features/feedback/domain/repository/feedback_repository.dart';

class DeleteFeedbackUsecase {
  final FeedbackRepository _repository;

  DeleteFeedbackUsecase(this._repository);

  Future<bool> call(String feedbackId) async {
    return await _repository.deleteFeedback(feedbackId);
  }
}
