import 'package:GreenConnectMobile/features/transaction/domain/entities/credit_transaction_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class GetCreditTransactionsUseCase {
  final TransactionRepository repository;
  GetCreditTransactionsUseCase(this.repository);

  Future<CreditTransactionListResponse> call({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? type,
  }) {
    return repository.getCreditTransactions(
      pageIndex: pageIndex,
      pageSize: pageSize,
      sortByCreatedAt: sortByCreatedAt,
      type: type,
    );
  }
}
