import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_my_payment_transactions_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/viewmodels/states/payment_transaction_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentTransactionViewModel extends Notifier<PaymentTransactionState> {
  late GetMyPaymentTransactionsUseCase _getMyPaymentTransactions;

  @override
  PaymentTransactionState build() {
    _getMyPaymentTransactions = ref.read(
      getMyPaymentTransactionsUsecaseProvider,
    );
    return PaymentTransactionState();
  }

  Future<void> fetchMyPaymentTransactions({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? status,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);
    try {
      final result = await _getMyPaymentTransactions(
        pageIndex: pageIndex,
        pageSize: pageSize,
        sortByCreatedAt: sortByCreatedAt,
        status: status,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH PAYMENT TRANSACTIONS: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }
}
