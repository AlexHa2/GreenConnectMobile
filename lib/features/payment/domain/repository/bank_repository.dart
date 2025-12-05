import 'package:GreenConnectMobile/features/payment/domain/entities/bank_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/entities/create_payment_url_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/entities/payment_url_response_entity.dart';

abstract class BankRepository {
  Future<List<BankEntity>> getBanks();
  Future<PaymentUrlResponseEntity> createPaymentUrl(CreatePaymentUrlEntity request);
}
