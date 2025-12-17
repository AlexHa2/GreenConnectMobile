import 'package:GreenConnectMobile/features/transaction/domain/entities/payment_transaction_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class GetMyPaymentTransactionsUseCase {
  final TransactionRepository repository;
  GetMyPaymentTransactionsUseCase(this.repository);

  Future<PaymentTransactionListResponse> call({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? status,
  }) {
    return repository.getMyPaymentTransactions(
      pageIndex: pageIndex,
      pageSize: pageSize,
      sortByCreatedAt: sortByCreatedAt,
      status: status,
    );
  }
}
