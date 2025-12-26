import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/payment/data/datasources/bank_remote_datasource.dart';
import 'package:GreenConnectMobile/features/payment/data/models/create_payment_url_model.dart';
import 'package:GreenConnectMobile/features/payment/domain/entities/bank_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/entities/create_payment_url_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/entities/payment_url_response_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/repository/bank_repository.dart';

class BankRepositoryImpl implements BankRepository {
  final BankRemoteDataSource remoteDataSource;

  BankRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<BankEntity>> getBanks() {
    return guard(() async {
      final models = await remoteDataSource.getBanks();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<PaymentUrlResponseEntity> createPaymentUrl(
      CreatePaymentUrlEntity request,) {
    return guard(() async {
      final model = CreatePaymentUrlModel.fromEntity(request);
      final response = await remoteDataSource.createPaymentUrl(model);
      return response.toEntity();
    });
  }
}
