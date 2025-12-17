import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/transaction/domain/usecases/get_credit_transactions_usecase.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/viewmodels/states/credit_transaction_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditTransactionViewModel extends Notifier<CreditTransactionState> {
  late GetCreditTransactionsUseCase _getCreditTransactions;

  @override
  CreditTransactionState build() {
    _getCreditTransactions = ref.read(getCreditTransactionsUsecaseProvider);
    return CreditTransactionState();
  }

  Future<void> fetchCreditTransactions({
    required int pageIndex,
    required int pageSize,
    bool? sortByCreatedAt,
    String? type,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);
    try {
      final result = await _getCreditTransactions(
        pageIndex: pageIndex,
        pageSize: pageSize,
        sortByCreatedAt: sortByCreatedAt,
        type: type,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH CREDIT TRANSACTIONS: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }

  void clearList() {
    state = state.copyWith(listData: null);
  }
}
