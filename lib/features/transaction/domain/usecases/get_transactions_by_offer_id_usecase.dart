import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class GetTransactionsByOfferIdUsecase {
  final TransactionRepository _repository;

  GetTransactionsByOfferIdUsecase(this._repository);

  Future<TransactionListResponse> call({
    required String offerId,
    String? status,
    bool? sortByCreateAtDesc,
    bool? sortByUpdateAtDesc,
    required int pageNumber,
    required int pageSize,
  }) async {
    return await _repository.getTransactionsByOfferId(
      offerId: offerId,
      status: status,
      sortByCreateAtDesc: sortByCreateAtDesc,
      sortByUpdateAtDesc: sortByUpdateAtDesc,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
