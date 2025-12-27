import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class ProcessTransactionUsecase {
  final TransactionRepository _repository;

  ProcessTransactionUsecase(this._repository);

  Future<bool> call({
    required String scrapPostId,
    required String collectorId,
    required String slotId,
    required bool isAccepted,
    String? paymentMethod,
  }) async {
    return await _repository.processTransaction(
      scrapPostId: scrapPostId,
      collectorId: collectorId,
      slotId: slotId,
      isAccepted: isAccepted,
      paymentMethod: paymentMethod,
    );
  }
}
