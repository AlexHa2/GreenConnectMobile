import 'package:GreenConnectMobile/features/transaction/domain/entities/feedback_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class GetTransactionFeedbacksUsecase {
  final TransactionRepository _repository;

  GetTransactionFeedbacksUsecase(this._repository);

  Future<FeedbackListResponse> call({
    required String transactionId,
    required int pageNumber,
    required int pageSize,
    bool? sortByCreateAt,
  }) async {
    return await _repository.getTransactionFeedbacks(
      transactionId: transactionId,
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortByCreateAt: sortByCreateAt,
    );
  }
}
