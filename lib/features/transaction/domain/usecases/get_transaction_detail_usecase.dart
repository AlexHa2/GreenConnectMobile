import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class GetTransactionDetailUsecase {
  final TransactionRepository _repository;

  GetTransactionDetailUsecase(this._repository);

  Future<TransactionEntity> call(String transactionId) async {
    return await _repository.getTransactionDetail(transactionId);
  }
}
