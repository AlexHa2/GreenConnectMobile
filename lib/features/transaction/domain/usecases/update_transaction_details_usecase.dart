import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class UpdateTransactionDetailsUsecase {
  final TransactionRepository _repository;

  UpdateTransactionDetailsUsecase(this._repository);

  Future<List<TransactionDetailEntity>> call({
    required String transactionId,
    required List<TransactionDetailRequest> details,
  }) async {
    return await _repository.updateTransactionDetails(
      transactionId: transactionId,
      details: details,
    );
  }
}
