import 'package:GreenConnectMobile/features/transaction/domain/entities/check_in_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/feedback_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_list_response.dart';

abstract class TransactionRepository {
  Future<TransactionListResponse> getAllTransactions({
    bool? sortByCreateAt,
    bool? sortByUpdateAt,
    required int pageNumber,
    required int pageSize,
  });

  Future<TransactionEntity> getTransactionDetail(String transactionId);

  Future<bool> checkIn({
    required String transactionId,
    required CheckInRequest request,
  });

  Future<List<TransactionDetailEntity>> updateTransactionDetails({
    required String transactionId,
    required List<TransactionDetailRequest> details,
  });

  Future<bool> processTransaction({
    required String transactionId,
    required bool isAccepted,
  });

  Future<bool> toggleCancelTransaction(String transactionId);

  Future<FeedbackListResponse> getTransactionFeedbacks({
    required String transactionId,
    required int pageNumber,
    required int pageSize,
    bool? sortByCreateAt,
  });

  Future<TransactionListResponse> getTransactionsByOfferId({
    required String offerId,
    String? status,
    bool? sortByCreateAtDesc,
    bool? sortByUpdateAtDesc,
    required int pageNumber,
    required int pageSize,
  });

  Future<String> getTransactionQRCode(String transactionId);
}
