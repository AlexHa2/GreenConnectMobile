import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class GetAllTransactionsUsecase {
  final TransactionRepository _repository;

  GetAllTransactionsUsecase(this._repository);

  Future<TransactionListResponse> call({
    bool? sortByCreateAt,
    bool? sortByUpdateAt,
    required int pageNumber,
    required int pageSize,
  }) async {
    return await _repository.getAllTransactions(
      sortByCreateAt: sortByCreateAt,
      sortByUpdateAt: sortByUpdateAt,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
