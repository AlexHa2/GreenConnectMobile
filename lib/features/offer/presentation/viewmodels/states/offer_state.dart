import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';

class OfferState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isProcessing;
  final String? errorMessage;

  final PaginatedOfferEntity? listData;
  final CollectionOfferEntity? detailData;

  OfferState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isProcessing = false,
    this.errorMessage,
    this.listData,
    this.detailData,
  });

  OfferState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isProcessing,
    String? errorMessage,
    PaginatedOfferEntity? listData,
    CollectionOfferEntity? detailData,
  }) {
    return OfferState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
    );
  }
}
