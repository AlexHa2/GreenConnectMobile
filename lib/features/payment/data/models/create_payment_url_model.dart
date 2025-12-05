import 'package:GreenConnectMobile/features/payment/domain/entities/create_payment_url_entity.dart';

class CreatePaymentUrlModel {
  final String packageId;

  CreatePaymentUrlModel({
    required this.packageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
    };
  }

  factory CreatePaymentUrlModel.fromEntity(CreatePaymentUrlEntity entity) {
    return CreatePaymentUrlModel(
      packageId: entity.packageId,
    );
  }
}
