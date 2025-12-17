import 'package:GreenConnectMobile/features/transaction/domain/entities/credit_transaction_list_response.dart';

class CreditTransactionState {
  final bool isLoadingList;
  final CreditTransactionListResponse? listData;
  final String? errorMessage;

  CreditTransactionState({
    this.isLoadingList = false,
    this.listData,
    this.errorMessage,
  });

  CreditTransactionState copyWith({
    bool? isLoadingList,
    CreditTransactionListResponse? listData,
    String? errorMessage,
  }) {
    return CreditTransactionState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      listData: listData ?? this.listData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
