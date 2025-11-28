import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_list_response.dart';
import 'package:GreenConnectMobile/features/feedback/domain/repository/feedback_repository.dart';

class GetMyFeedbacksUsecase {
  final FeedbackRepository _repository;

  GetMyFeedbacksUsecase(this._repository);

  Future<FeedbackListResponse> call({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatAt,
  }) async {
    return await _repository.getMyFeedbacks(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortByCreatAt: sortByCreatAt,
    );
  }
}
