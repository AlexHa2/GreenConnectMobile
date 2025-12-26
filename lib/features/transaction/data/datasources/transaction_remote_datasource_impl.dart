import 'dart:convert';

import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/credit_payment_transaction_list_response_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/feedback_list_response_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_detail_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_list_response_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/check_in_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:flutter/foundation.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  static const String _creditTransactionBaseUrl = '/v1/credit-transaction';
  static const String _paymentTransactionBaseUrl =
      '/v1/payment-transaction/my-transactions';
  static const String _transactionsBaseUrl = '/v1/transactions';

  @override
  Future<CreditTransactionListResponseModel> getCreditTransactions({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? type,
  }) async {
    final queryParams = <String, dynamic>{
      'pageIndex': pageIndex,
      'pageSize': pageSize,
    };
    if (sortByCreatedAt != null) {
      queryParams['sortByCreatedAt'] = sortByCreatedAt;
    }
    if (type != null) {
      queryParams['type'] = type;
    }
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    final res = await _apiClient.get('$_creditTransactionBaseUrl?$queryString');
    return CreditTransactionListResponseModel.fromJson(res.data);
  }

  @override
  Future<PaymentTransactionListResponseModel> getMyPaymentTransactions({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'pageIndex': pageIndex,
      'pageSize': pageSize,
    };
    if (sortByCreatedAt != null) {
      queryParams['sortByCreatedAt'] = sortByCreatedAt;
    }
    if (status != null) {
      queryParams['status'] = status;
    }
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    final res = await _apiClient.get(
      '$_paymentTransactionBaseUrl?$queryString',
    );
    return PaymentTransactionListResponseModel.fromJson(res.data);
  }

  @override
  Future<TransactionListResponseModel> getAllTransactions({
    bool? sortByCreateAt,
    bool? sortByUpdateAt,
    required int pageNumber,
    required int pageSize,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    if (sortByCreateAt != null) {
      queryParams['sortByCreateAt'] = sortByCreateAt;
    }
    if (sortByUpdateAt != null) {
      queryParams['sortByUpdateAt'] = sortByUpdateAt;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final res = await _apiClient.get('$_transactionsBaseUrl?$queryString');
    return TransactionListResponseModel.fromJson(res.data);
  }

  @override
  Future<TransactionModel> getTransactionDetail(String transactionId) async {
    final res = await _apiClient.get('$_transactionsBaseUrl/$transactionId');
    return TransactionModel.fromJson(res.data);
  }

  @override
  Future<bool> checkIn({
    required String transactionId,
    required CheckInRequest request,
  }) async {
    final res = await _apiClient.patch(
      '$_transactionsBaseUrl/$transactionId/check-in',
      data: request.toJson(),
    );
    return res.statusCode == 200;
  }

  @override
  Future<List<TransactionDetailModel>> updateTransactionDetails({
    required String scrapPostId,
    required String slotId,
    required List<TransactionDetailRequest> details,
  }) async {
    final queryParams = <String, dynamic>{
      'scrapPostId': scrapPostId,
      'slotId': slotId,
    };
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    
    // Convert to JSON-serializable format
    final requestBody = details.map((e) => e.toJson()).toList();
    
    // Debug: Log the request body to verify format
    if (kDebugMode) {
      debugPrint('🔍 [updateTransactionDetails] Request body:');
      debugPrint(jsonEncode(requestBody));
      debugPrint('🔍 [updateTransactionDetails] URL: $_transactionsBaseUrl/details?$queryString');
    }
    
    final res = await _apiClient.post(
      '$_transactionsBaseUrl/details?$queryString',
      data: requestBody,
    );
    return (res.data as List)
        .map((e) => TransactionDetailModel.fromJson(e))
        .toList();
  }

  @override
  Future<bool> processTransaction({
    required String scrapPostId,
    required String collectorId,
    required String slotId,
    required bool isAccepted,
    String? paymentMethod,
  }) async {
    final queryParams = <String, dynamic>{
      'scrapPostId': scrapPostId,
      'collectorId': collectorId,
      'slotId': slotId,
      'isAccepted': isAccepted,
    };
    
    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      queryParams['paymentMethod'] = paymentMethod;
    }
    
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    
    final res = await _apiClient.patch(
      '$_transactionsBaseUrl/process?$queryString',
    );
    return res.statusCode == 200;
  }

  @override
  Future<bool> toggleCancelTransaction(String transactionId) async {
    final res = await _apiClient.patch(
      '$_transactionsBaseUrl/$transactionId/toggle-cancel',
    );
    return res.statusCode == 200;
  }

  @override
  Future<FeedbackListResponseModel> getTransactionFeedbacks({
    required String transactionId,
    required int pageNumber,
    required int pageSize,
    bool? sortByCreateAt,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    if (sortByCreateAt != null) {
      queryParams['sortByCreateAt'] = sortByCreateAt;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final res = await _apiClient.get(
      '$_transactionsBaseUrl/$transactionId/feedbacks?$queryString',
    );
    return FeedbackListResponseModel.fromJson(res.data);
  }

  @override
  Future<TransactionListResponseModel> getTransactionsByOfferId({
    required String offerId,
    String? status,
    bool? sortByCreateAtDesc,
    bool? sortByUpdateAtDesc,
    required int pageNumber,
    required int pageSize,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    if (status != null) {
      queryParams['status'] = status;
    }
    if (sortByCreateAtDesc != null) {
      queryParams['sortByCreateAtDesc'] = sortByCreateAtDesc;
    }
    if (sortByUpdateAtDesc != null) {
      queryParams['sortByUpdateAtDesc'] = sortByUpdateAtDesc;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final res = await _apiClient.get(
      '/v1/offers/$offerId/transactions?$queryString',
    );
    return TransactionListResponseModel.fromJson(res.data);
  }

  @override
  Future<String> getTransactionQRCode(String transactionId) async {
    final res = await _apiClient.get(
      '$_transactionsBaseUrl/$transactionId/qr-code',
    );
    // API returns QR code URL in qrUrl field
    if (res.data is Map && res.data['qrUrl'] != null) {
      return res.data['qrUrl'] as String;
    }
    throw Exception('Invalid QR code response format: qrUrl not found');
  }
}
