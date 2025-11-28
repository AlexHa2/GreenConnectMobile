import 'package:GreenConnectMobile/features/transaction/domain/entities/check_in_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class CheckInUsecase {
  final TransactionRepository _repository;

  CheckInUsecase(this._repository);

  Future<bool> call({
    required String transactionId,
    required CheckInRequest request,
  }) async {
    return await _repository.checkIn(
      transactionId: transactionId,
      request: request,
    );
  }
}
