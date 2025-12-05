import 'package:GreenConnectMobile/features/payment/domain/entities/payment_url_response_entity.dart';

class PaymentUrlResponseModel {
  final String paymentUrl;
  final String transactionRef;

  PaymentUrlResponseModel({
    required this.paymentUrl,
    required this.transactionRef,
  });

  factory PaymentUrlResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentUrlResponseModel(
      paymentUrl: json['paymentUrl'] as String,
      transactionRef: json['transactionRef'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentUrl': paymentUrl,
      'transactionRef': transactionRef,
    };
  }

  PaymentUrlResponseEntity toEntity() {
    return PaymentUrlResponseEntity(
      paymentUrl: paymentUrl,
      transactionRef: transactionRef,
    );
  }
}
