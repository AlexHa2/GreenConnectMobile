import 'package:GreenConnectMobile/features/transaction/domain/entities/payment_transaction_list_response.dart';

class PaymentTransactionState {
  final bool isLoadingList;
  final PaymentTransactionListResponse? listData;
  final String? errorMessage;


  PaymentTransactionState({
    this.isLoadingList = false,
    this.listData,
    this.errorMessage,
  });

  PaymentTransactionState copyWith({
    bool? isLoadingList,
    PaymentTransactionListResponse? listData,
    String? errorMessage,
    String? currentFilter,
    bool? isSortDesc,
  }) {
    return PaymentTransactionState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      listData: listData ?? this.listData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
