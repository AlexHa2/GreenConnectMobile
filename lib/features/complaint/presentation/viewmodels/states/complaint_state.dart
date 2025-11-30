import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_list_response.dart';

class ComplaintState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isProcessing;
  final ComplaintListResponse? listData;
  final ComplaintEntity? detailData;
  final String? errorMessage;

  ComplaintState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isProcessing = false,
    this.listData,
    this.detailData,
    this.errorMessage,
  });

  ComplaintState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isProcessing,
    ComplaintListResponse? listData,
    ComplaintEntity? detailData,
    String? errorMessage,
  }) {
    return ComplaintState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isProcessing: isProcessing ?? this.isProcessing,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
