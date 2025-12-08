import 'package:GreenConnectMobile/features/package/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/package/domain/entities/pagination_entity.dart';

class PackageState {
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final List<PackageEntity> packages;
  final PaginationEntity? pagination;
  final PackageEntity? selectedPackage;
  final bool isLoadingDetail;
  final String? detailErrorMessage;
  final bool isProcessing; // For payment processing
  final String? paymentUrl;
  final String? transactionRef;

  PackageState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.packages = const [],
    this.pagination,
    this.selectedPackage,
    this.isLoadingDetail = false,
    this.detailErrorMessage,
    this.isProcessing = false,
    this.paymentUrl,
    this.transactionRef,
  });

  PackageState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    List<PackageEntity>? packages,
    PaginationEntity? pagination,
    PackageEntity? selectedPackage,
    bool? isLoadingDetail,
    String? detailErrorMessage,
    bool? isProcessing,
    String? paymentUrl,
    String? transactionRef,
    bool clearError = false,
    bool clearDetailError = false,
    bool clearPayment = false,
  }) {
    return PackageState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      packages: packages ?? this.packages,
      pagination: pagination ?? this.pagination,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      detailErrorMessage: clearDetailError
          ? null
          : (detailErrorMessage ?? this.detailErrorMessage),
      isProcessing: isProcessing ?? this.isProcessing,
      paymentUrl: clearPayment ? null : (paymentUrl ?? this.paymentUrl),
      transactionRef: clearPayment ? null : (transactionRef ?? this.transactionRef),
    );
  }
}
