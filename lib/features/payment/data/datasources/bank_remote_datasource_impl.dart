import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/payment/data/datasources/bank_remote_datasource.dart';
import 'package:GreenConnectMobile/features/payment/data/models/bank_model.dart';
import 'package:GreenConnectMobile/features/payment/data/models/create_payment_url_model.dart';
import 'package:GreenConnectMobile/features/payment/data/models/payment_url_response_model.dart';

class BankRemoteDataSourceImpl implements BankRemoteDataSource {
  final ApiClient apiClient;
  final _baseURLBank = '/v1/banks';
  final _baseURLPayment = '/v1/payment';

  BankRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<BankModel>> getBanks() async {
    final response = await apiClient.get(_baseURLBank);
    return (response.data as List)
        .map((json) => BankModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PaymentUrlResponseModel> createPaymentUrl(
      CreatePaymentUrlModel request) async {
    final response = await apiClient.post(
      '$_baseURLPayment/create-url',
      data: request.toJson(),
    );
    return PaymentUrlResponseModel.fromJson(
        response.data as Map<String, dynamic>);
  }
}
