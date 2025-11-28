import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_entity.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_list_response.dart';

class RewardItemState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isProcessing;
  final RewardItemListResponse? listData;
  final RewardItemEntity? detailData;
  final String? errorMessage;

  RewardItemState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isProcessing = false,
    this.listData,
    this.detailData,
    this.errorMessage,
  });

  RewardItemState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isProcessing,
    RewardItemListResponse? listData,
    RewardItemEntity? detailData,
    String? errorMessage,
  }) {
    return RewardItemState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isProcessing: isProcessing ?? this.isProcessing,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}