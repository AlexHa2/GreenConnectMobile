import 'package:GreenConnectMobile/features/reward/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/paginated_packages_entity.dart';

class PackageState {
  final bool isLoading;
  final String? errorMessage;
  final int? errorCode;
  final PaginatedPackagesEntity? packages;
  final PackageEntity? selectedPackage;

  PackageState({
    this.isLoading = false,
    this.errorMessage,
    this.errorCode,
    this.packages,
    this.selectedPackage,
  });

  PackageState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? errorCode,
    PaginatedPackagesEntity? packages,
    PackageEntity? selectedPackage,
  }) {
    return PackageState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      errorCode: errorCode,
      packages: packages ?? this.packages,
      selectedPackage: selectedPackage ?? this.selectedPackage,
    );
  }
}
