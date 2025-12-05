import 'package:GreenConnectMobile/features/payment/domain/entities/create_payment_url_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/entities/payment_url_response_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/repository/bank_repository.dart';

class CreatePaymentUrlUsecase {
  final BankRepository repository;

  CreatePaymentUrlUsecase(this.repository);

  Future<PaymentUrlResponseEntity> call(CreatePaymentUrlEntity entity) {
    return repository.createPaymentUrl(entity);
  }
}
