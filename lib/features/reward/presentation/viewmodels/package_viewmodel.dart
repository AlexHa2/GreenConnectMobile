import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_package_by_id_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_packages_usecase.dart';
import 'package:GreenConnectMobile/features/reward/presentation/providers/package_providers.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/states/package_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageViewModel extends Notifier<PackageState> {
  late GetPackagesUseCase _getPackagesUseCase;
  late GetPackageByIdUseCase _getPackageByIdUseCase;

  @override
  PackageState build() {
    _getPackagesUseCase = ref.read(getPackagesUsecaseProvider);
    _getPackageByIdUseCase = ref.read(getPackageByIdUsecaseProvider);
    return PackageState();
  }

  Future<void> fetchPackages({
    int pageNumber = 1,
    int pageSize = 10,
    bool? sortByPrice,
    String? packageType,
    String? name,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    try {
      final packages = await _getPackagesUseCase(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortByPrice: sortByPrice,
        packageType: packageType,
        name: name,
      );

      state = state.copyWith(
        isLoading: false,
        packages: packages,
        errorMessage: null,
        errorCode: null,
      );
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH PACKAGES: ${e.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          errorCode: e.statusCode,
        );
      } else {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      debugPrint('📌 STACK TRACE: $stack');
    }
  }

  Future<void> fetchPackageById(String packageId) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    try {
      final packageDetail = await _getPackageByIdUseCase(packageId);

      state = state.copyWith(
        isLoading: false,
        selectedPackage: packageDetail,
        errorMessage: null,
        errorCode: null,
      );
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH PACKAGE BY ID: ${e.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          errorCode: e.statusCode,
        );
      } else {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      debugPrint('📌 STACK TRACE: $stack');
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
