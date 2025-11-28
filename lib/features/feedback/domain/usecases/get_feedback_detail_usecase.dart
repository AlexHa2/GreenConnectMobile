import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_entity.dart';
import 'package:GreenConnectMobile/features/feedback/domain/repository/feedback_repository.dart';

class GetFeedbackDetailUsecase {
  final FeedbackRepository _repository;

  GetFeedbackDetailUsecase(this._repository);

  Future<FeedbackEntity> call(String feedbackId) async {
    return await _repository.getFeedbackDetail(feedbackId);
  }
}
