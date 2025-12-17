import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/check_in_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/credit_transaction_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/feedback_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/payment_transaction_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepositoryImpl(this._remoteDataSource);

  @override
  Future<TransactionListResponse> getAllTransactions({
    bool? sortByCreateAt,
    bool? sortByUpdateAt,
    required int pageNumber,
    required int pageSize,
  }) async {
    return guard(() async {
      final result = await _remoteDataSource.getAllTransactions(
        sortByCreateAt: sortByCreateAt,
        sortByUpdateAt: sortByUpdateAt,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return result.toEntity();
    });
  }

  @override
  Future<TransactionEntity> getTransactionDetail(String transactionId) async {
    return guard(() async {
      final result = await _remoteDataSource.getTransactionDetail(transactionId);
      return result.toEntity();
    });
  }

  @override
  Future<bool> checkIn({
    required String transactionId,
    required CheckInRequest request,
  }) async {
    return guard(() async {
      return await _remoteDataSource.checkIn(
        transactionId: transactionId,
        request: request,
      );
    });
  }

  @override
  Future<List<TransactionDetailEntity>> updateTransactionDetails({
    required String transactionId,
    required List<TransactionDetailRequest> details,
  }) async {
    return guard(() async {
      final result = await _remoteDataSource.updateTransactionDetails(
        transactionId: transactionId,
        details: details,
      );
      return result.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<bool> processTransaction({
    required String transactionId,
    required bool isAccepted,
  }) async {
    return guard(() async {
      return await _remoteDataSource.processTransaction(
        transactionId: transactionId,
        isAccepted: isAccepted,
      );
    });
  }

  @override
  Future<bool> toggleCancelTransaction(String transactionId) async {
    return guard(() async {
      return await _remoteDataSource.toggleCancelTransaction(transactionId);
    });
  }

  @override
  Future<FeedbackListResponse> getTransactionFeedbacks({
    required String transactionId,
    required int pageNumber,
    required int pageSize,
    bool? sortByCreateAt,
  }) async {
    return guard(() async {
      final result = await _remoteDataSource.getTransactionFeedbacks(
        transactionId: transactionId,
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortByCreateAt: sortByCreateAt,
      );
      return result.toEntity();
    });
  }

  @override
  Future<TransactionListResponse> getTransactionsByOfferId({
    required String offerId,
    String? status,
    bool? sortByCreateAtDesc,
    bool? sortByUpdateAtDesc,
    required int pageNumber,
    required int pageSize,
  }) async {
    return guard(() async {
      final result = await _remoteDataSource.getTransactionsByOfferId(
        offerId: offerId,
        status: status,
        sortByCreateAtDesc: sortByCreateAtDesc,
        sortByUpdateAtDesc: sortByUpdateAtDesc,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return result.toEntity();
    });
  }

  @override
  Future<String> getTransactionQRCode(String transactionId) async {
    return guard(() async {
      return await _remoteDataSource.getTransactionQRCode(transactionId);
    });
  }

  @override
  Future<CreditTransactionListResponse> getCreditTransactions({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? type,
  }) async {
    return guard(() async {
      final result = await _remoteDataSource.getCreditTransactions(
        pageIndex: pageIndex,
        pageSize: pageSize,
        sortByCreatedAt: sortByCreatedAt,
        type: type,
      );
      return result.toEntity();
    });
  }

  @override
  Future<PaymentTransactionListResponse> getMyPaymentTransactions({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? status,
  }) async {
    return guard(() async {
      final result = await _remoteDataSource.getMyPaymentTransactions(
        pageIndex: pageIndex,
        pageSize: pageSize,
        sortByCreatedAt: sortByCreatedAt,
        status: status,
      );
      return result.toEntity();
    });
  }
}
