import 'package:GreenConnectMobile/features/payment/domain/entities/bank_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/entities/payment_url_response_entity.dart';

class BankState {
  final bool isLoading;
  final bool isCreatingPayment;
  final String? errorMessage;
  final List<BankEntity>? banks;
  final PaymentUrlResponseEntity? paymentUrlResponse;

  BankState({
    this.isLoading = false,
    this.isCreatingPayment = false,
    this.errorMessage,
    this.banks,
    this.paymentUrlResponse,
  });

  BankState copyWith({
    bool? isLoading,
    bool? isCreatingPayment,
    String? errorMessage,
    List<BankEntity>? banks,
    PaymentUrlResponseEntity? paymentUrlResponse,
  }) {
    return BankState(
      isLoading: isLoading ?? this.isLoading,
      isCreatingPayment: isCreatingPayment ?? this.isCreatingPayment,
      errorMessage: errorMessage,
      banks: banks ?? this.banks,
      paymentUrlResponse: paymentUrlResponse ?? this.paymentUrlResponse,
    );
  }
}
