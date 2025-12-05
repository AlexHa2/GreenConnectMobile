import 'package:GreenConnectMobile/features/payment/domain/entities/create_payment_url_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/usecases/create_payment_url_usecase.dart';
import 'package:GreenConnectMobile/features/payment/domain/usecases/get_banks_usecase.dart';
import 'package:GreenConnectMobile/features/payment/presentation/providers/bank_providers.dart';
import 'package:GreenConnectMobile/features/payment/presentation/viewmodels/states/bank_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankViewModel extends Notifier<BankState> {
  late final GetBanksUsecase _getBanksUsecase;
  late final CreatePaymentUrlUsecase _createPaymentUrlUsecase;

  @override
  BankState build() {
    _getBanksUsecase = ref.read(getBanksUsecaseProvider);
    _createPaymentUrlUsecase = ref.read(createPaymentUrlUsecaseProvider);
    return BankState();
  }

  Future<void> fetchBanks() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final banks = await _getBanksUsecase();
      state = state.copyWith(
        isLoading: false,
        banks: banks,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> createPaymentUrl(String packageId) async {
    state = state.copyWith(isCreatingPayment: true, errorMessage: null);

    try {
      final entity = CreatePaymentUrlEntity(packageId: packageId);
      final response = await _createPaymentUrlUsecase(entity);
      state = state.copyWith(
        isCreatingPayment: false,
        paymentUrlResponse: response,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isCreatingPayment: false,
        errorMessage: e.toString(),
      );
    }
  }
}
