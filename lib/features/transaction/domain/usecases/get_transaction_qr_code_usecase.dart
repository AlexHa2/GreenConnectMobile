import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class GetTransactionQRCodeUsecase {
  final TransactionRepository _repository;

  GetTransactionQRCodeUsecase(this._repository);

  Future<String> call(String transactionId, double totalAmount) async {
    return await _repository.getTransactionQRCode(transactionId, totalAmount);
  }
}
