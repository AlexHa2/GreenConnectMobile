import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/package/domain/usecases/get_package_by_id_usecase.dart';
import 'package:GreenConnectMobile/features/package/domain/usecases/get_packages_usecase.dart';
import 'package:GreenConnectMobile/features/package/presentation/providers/package_providers.dart';
import 'package:GreenConnectMobile/features/package/presentation/viewmodels/states/package_state.dart';
import 'package:GreenConnectMobile/features/payment/domain/entities/create_payment_url_entity.dart';
import 'package:GreenConnectMobile/features/payment/domain/usecases/create_payment_url_usecase.dart';
import 'package:GreenConnectMobile/features/payment/presentation/providers/bank_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageViewModel extends Notifier<PackageState> {
  late final GetPackagesUseCase _getPackagesUseCase;
  late final GetPackageByIdUseCase _getPackageByIdUseCase;
  late final CreatePaymentUrlUsecase _createPaymentUrlUsecase;

  @override
  PackageState build() {
    _getPackagesUseCase = ref.read(getPackagesUseCaseProvider);
    _getPackageByIdUseCase = ref.read(getPackageByIdUseCaseProvider);
    _createPaymentUrlUsecase = ref.read(createPaymentUrlUsecaseProvider);
    return PackageState();
  }

  Future<void> fetchPackages({
    int pageNumber = 1,
    int pageSize = 10,
    bool? sortByPrice,
    String? packageType,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      state = state.copyWith(isLoadingMore: true, clearError: true);
    } else {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final response = await _getPackagesUseCase(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortByPrice: sortByPrice,
        packageType: packageType,
      );

      final updatedPackages = isLoadMore
          ? [...state.packages, ...response.data]
          : response.data;

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        packages: updatedPackages,
        pagination: response.pagination,
      );
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH PACKAGES: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: errorMsg,
      );
    }
  }

  Future<void> fetchPackageById(String packageId) async {
    state = state.copyWith(isLoadingDetail: true, clearDetailError: true);

    try {
      final package = await _getPackageByIdUseCase(packageId);

      state = state.copyWith(isLoadingDetail: false, selectedPackage: package);
    } catch (e, stack) {
      String errorMsg = 'An error occurred';
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH PACKAGE BY ID: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(
        isLoadingDetail: false,
        detailErrorMessage: errorMsg,
      );
    }
  }

  void clearSelectedPackage() {
    state = state.copyWith(selectedPackage: null, clearDetailError: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> createPaymentUrl(String packageId) async {
    state = state.copyWith(isProcessing: true, clearPayment: true);

    try {
      final response = await _createPaymentUrlUsecase(
        CreatePaymentUrlEntity(packageId: packageId),
      );

      state = state.copyWith(
        isProcessing: false,
        paymentUrl: response.paymentUrl,
        transactionRef: response.transactionRef,
      );
    } catch (e, stack) {
      String errorMsg = 'Failed to create payment URL';
      if (e is AppException) {
        debugPrint('❌ ERROR CREATE PAYMENT URL: ${e.message}');
        errorMsg = e.message ?? errorMsg;
      } else {
        errorMsg = e.toString();
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(
        isProcessing: false,
        errorMessage: errorMsg,
      );
    }
  }

  void clearPaymentData() {
    state = state.copyWith(clearPayment: true);
  }
}
