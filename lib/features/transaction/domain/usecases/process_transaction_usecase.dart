import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class ProcessTransactionUsecase {
  final TransactionRepository _repository;

  ProcessTransactionUsecase(this._repository);

  Future<bool> call({
    required String transactionId,
    required bool isAccepted,
  }) async {
    return await _repository.processTransaction(
      transactionId: transactionId,
      isAccepted: isAccepted,
    );
  }
}
