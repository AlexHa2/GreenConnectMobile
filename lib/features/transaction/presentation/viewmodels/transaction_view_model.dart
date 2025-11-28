import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/check_in_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/check_in_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_all_transactions_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_transaction_detail_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_transaction_feedbacks_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_transactions_by_offer_id_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/process_transaction_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/toggle_cancel_transaction_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/update_transaction_details_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/viewmodels/states/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionViewModel extends Notifier<TransactionState> {
  late GetAllTransactionsUsecase _getAllTransactions;
  late GetTransactionDetailUsecase _getTransactionDetail;
  late CheckInUsecase _checkIn;
  late UpdateTransactionDetailsUsecase _updateDetails;
  late ProcessTransactionUsecase _processTransaction;
  late ToggleCancelTransactionUsecase _toggleCancel;
  late GetTransactionFeedbacksUsecase _getFeedbacks;
  late GetTransactionsByOfferIdUsecase _getTransactionsByOfferId;

  @override
  TransactionState build() {
    _getAllTransactions = ref.read(getAllTransactionsUsecaseProvider);
    _getTransactionDetail = ref.read(getTransactionDetailUsecaseProvider);
    _checkIn = ref.read(checkInUsecaseProvider);
    _updateDetails = ref.read(updateTransactionDetailsUsecaseProvider);
    _processTransaction = ref.read(processTransactionUsecaseProvider);
    _toggleCancel = ref.read(toggleCancelTransactionUsecaseProvider);
    _getFeedbacks = ref.read(getTransactionFeedbacksUsecaseProvider);
    _getTransactionsByOfferId =
        ref.read(getTransactionsByOfferIdUsecaseProvider);
    return TransactionState();
  }

  /// Fetch all transactions with pagination
  Future<void> fetchAllTransactions({
    bool? sortByCreateAt,
    bool? sortByUpdateAt,
    required int page,
    required int size,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _getAllTransactions(
        sortByCreateAt: sortByCreateAt,
        sortByUpdateAt: sortByUpdateAt,
        pageNumber: page,
        pageSize: size,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH TRANSACTIONS: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }

  /// Fetch transaction detail
  Future<void> fetchTransactionDetail(String transactionId) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);

    try {
      final result = await _getTransactionDetail(transactionId);
      state = state.copyWith(isLoadingDetail: false, detailData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH TRANSACTION DETAIL: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state =
          state.copyWith(isLoadingDetail: false, errorMessage: e.toString());
    }
  }

  /// Check in to start transaction
  Future<bool> checkInTransaction({
    required String transactionId,
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final request = CheckInRequest(latitude: latitude, longitude: longitude);
      final success = await _checkIn(
        transactionId: transactionId,
        request: request,
      );
      state = state.copyWith(isProcessing: false);

      if (success) {
        // Refresh detail after check-in
        await fetchTransactionDetail(transactionId);
      }
      return success;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR CHECK-IN: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Update transaction details (weight/quantity)
  Future<bool> updateTransactionDetails({
    required String transactionId,
    required List<TransactionDetailRequest> details,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final result = await _updateDetails(
        transactionId: transactionId,
        details: details,
      );
      state = state.copyWith(isProcessing: false);

      if (result.isNotEmpty) {
        // Refresh detail after update
        await fetchTransactionDetail(transactionId);
        return true;
      }
      return false;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE DETAILS: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Process transaction (Accept/Reject by Household)
  Future<bool> processTransaction({
    required String transactionId,
    required bool isAccepted,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final success = await _processTransaction(
        transactionId: transactionId,
        isAccepted: isAccepted,
      );
      state = state.copyWith(isProcessing: false);

      if (success) {
        // Refresh detail after process
        await fetchTransactionDetail(transactionId);
      }
      return success;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR PROCESS TRANSACTION: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Toggle cancel transaction
  Future<bool> toggleCancelTransaction(String transactionId) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final success = await _toggleCancel(transactionId);
      state = state.copyWith(isProcessing: false);

      if (success) {
        // Refresh detail after toggle
        await fetchTransactionDetail(transactionId);
      }
      return success;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR TOGGLE CANCEL: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Fetch transaction feedbacks
  Future<void> fetchTransactionFeedbacks({
    required String transactionId,
    required int page,
    required int size,
    bool? sortByCreateAt,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _getFeedbacks(
        transactionId: transactionId,
        pageNumber: page,
        pageSize: size,
        sortByCreateAt: sortByCreateAt,
      );
      state = state.copyWith(isLoadingList: false, feedbackData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH FEEDBACKS: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }

  /// Fetch transactions by offer ID
  Future<void> fetchTransactionsByOfferId({
    required String offerId,
    String? status,
    bool? sortByCreateAtDesc,
    bool? sortByUpdateAtDesc,
    required int page,
    required int size,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _getTransactionsByOfferId(
        offerId: offerId,
        status: status,
        sortByCreateAtDesc: sortByCreateAtDesc,
        sortByUpdateAtDesc: sortByUpdateAtDesc,
        pageNumber: page,
        pageSize: size,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH TRANSACTIONS BY OFFER: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }
}
