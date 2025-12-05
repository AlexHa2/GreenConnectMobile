import 'package:GreenConnectMobile/features/payment/data/models/bank_model.dart';
import 'package:GreenConnectMobile/features/payment/data/models/create_payment_url_model.dart';
import 'package:GreenConnectMobile/features/payment/data/models/payment_url_response_model.dart';

abstract class BankRemoteDataSource {
  Future<List<BankModel>> getBanks();
  Future<PaymentUrlResponseModel> createPaymentUrl(CreatePaymentUrlModel request);
}
