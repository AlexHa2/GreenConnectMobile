import 'package:GreenConnectMobile/features/transaction/data/models/credit_payment_transaction_list_response_model.dart';
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

  /// POST /v1/transactions/details?scrapPostId={scrapPostId}&slotId={slotId}
  Future<List<TransactionDetailModel>> updateTransactionDetails({
    required String scrapPostId,
    required String slotId,
    required List<TransactionDetailRequest> details,
  });

  /// PATCH /v1/transactions/process?scrapPostId={scrapPostId}&collectorId={collectorId}&slotId={slotId}&isAccepted={isAccepted}&paymentMethod={paymentMethod}
  Future<bool> processTransaction({
    required String scrapPostId,
    required String collectorId,
    required String slotId,
    required bool isAccepted,
    String? paymentMethod, // "BankTransfer" or "Cash"
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

  /// GET /v1/transactions/{id}/qr-code
  Future<String> getTransactionQRCode(String transactionId);

  /// GET /api/v1/credit-transaction
  Future<CreditTransactionListResponseModel> getCreditTransactions({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? type, // Purchase, Usage, Refund, Bonus
  });

  /// GET /api/v1/payment-transaction/my-transactions
  Future<PaymentTransactionListResponseModel> getMyPaymentTransactions({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? status, // Pending, Success, Failed
  });
}
