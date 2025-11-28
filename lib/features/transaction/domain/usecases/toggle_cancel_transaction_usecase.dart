import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class ToggleCancelTransactionUsecase {
  final TransactionRepository _repository;

  ToggleCancelTransactionUsecase(this._repository);

  Future<bool> call(String transactionId) async {
    return await _repository.toggleCancelTransaction(transactionId);
  }
}
