import 'package:GreenConnectMobile/features/transaction/data/models/feedback_list_response_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_detail_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_list_response_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/check_in_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';

abstract class TransactionRemoteDataSource {
  /// GET /v1/transactions
  Future<TransactionListResponseModel> getAllTransactions({
    bool? sortByCreateAt,
    bool? sortByUpdateAt,
    required int pageNumber,
    required int pageSize,
  });

  /// GET /v1/transactions/{id}
  Future<TransactionModel> getTransactionDetail(String transactionId);

  /// PATCH /v1/transactions/{id}/check-in
  Future<bool> checkIn({
    required String transactionId,
    required CheckInRequest request,
  });

  /// POST /v1/transactions/{id}/details
  Future<List<TransactionDetailModel>> updateTransactionDetails({
    required String transactionId,
    required List<TransactionDetailRequest> details,
  });

  /// PATCH /v1/transactions/{id}/process
  Future<bool> processTransaction({
    required String transactionId,
    required bool isAccepted,
  });

  /// PATCH /v1/transactions/{id}/toggle-cancel
  Future<bool> toggleCancelTransaction(String transactionId);

  /// GET /v1/transactions/{id}/feedbacks
  Future<FeedbackListResponseModel> getTransactionFeedbacks({
    required String transactionId,
    required int pageNumber,
    required int pageSize,
    bool? sortByCreateAt,
  });

  /// GET /v1/offers/{offerId}/transactions
  Future<TransactionListResponseModel> getTransactionsByOfferId({
    required String offerId,
    String? status,
    bool? sortByCreateAtDesc,
    bool? sortByUpdateAtDesc,
    required int pageNumber,
    required int pageSize,
  });
}
