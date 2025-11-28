import 'package:GreenConnectMobile/features/feedback/domain/entities/create_feedback_request.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_entity.dart';
import 'package:GreenConnectMobile/features/feedback/domain/repository/feedback_repository.dart';

class CreateFeedbackUsecase {
  final FeedbackRepository _repository;

  CreateFeedbackUsecase(this._repository);

  Future<FeedbackEntity> call(CreateFeedbackRequest request) async {
    return await _repository.createFeedback(request);
  }
}
