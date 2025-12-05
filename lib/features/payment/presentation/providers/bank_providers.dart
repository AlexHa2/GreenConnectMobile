import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/payment/data/datasources/bank_remote_datasource.dart';
import 'package:GreenConnectMobile/features/payment/data/datasources/bank_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/payment/data/repository/bank_repository_impl.dart';
import 'package:GreenConnectMobile/features/payment/domain/repository/bank_repository.dart';
import 'package:GreenConnectMobile/features/payment/domain/usecases/create_payment_url_usecase.dart';
import 'package:GreenConnectMobile/features/payment/domain/usecases/get_banks_usecase.dart';
import 'package:GreenConnectMobile/features/payment/presentation/viewmodels/bank_view_model.dart';
import 'package:GreenConnectMobile/features/payment/presentation/viewmodels/states/bank_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Source
final bankRemoteDataSourceProvider = Provider<BankRemoteDataSource>((ref) {
  return BankRemoteDataSourceImpl(sl<ApiClient>());
});

// Repository
final bankRepositoryProvider = Provider<BankRepository>((ref) {
  return BankRepositoryImpl(ref.read(bankRemoteDataSourceProvider));
});

// Use Cases
final getBanksUsecaseProvider = Provider<GetBanksUsecase>((ref) {
  return GetBanksUsecase(ref.read(bankRepositoryProvider));
});

final createPaymentUrlUsecaseProvider = Provider<CreatePaymentUrlUsecase>((ref) {
  return CreatePaymentUrlUsecase(ref.read(bankRepositoryProvider));
});

// ViewModel
final bankViewModelProvider = NotifierProvider<BankViewModel, BankState>(() {
  return BankViewModel();
});
