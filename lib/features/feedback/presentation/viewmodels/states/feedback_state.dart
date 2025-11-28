import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_entity.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_list_response.dart';

class FeedbackState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isProcessing; // for create, update, delete
  final FeedbackListResponse? listData;
  final FeedbackEntity? detailData;
  final String? errorMessage;

  FeedbackState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isProcessing = false,
    this.listData,
    this.detailData,
    this.errorMessage,
  });

  FeedbackState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isProcessing,
    FeedbackListResponse? listData,
    FeedbackEntity? detailData,
    String? errorMessage,
  }) {
    return FeedbackState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isProcessing: isProcessing ?? this.isProcessing,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
