import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_list_response.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_proposal_entity.dart';

class ScheduleState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isProcessing;
  final ScheduleListResponse? listData;
  final ScheduleProposalEntity? detailData;
  final String? errorMessage;

  ScheduleState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isProcessing = false,
    this.listData,
    this.detailData,
    this.errorMessage,
  });

  ScheduleState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isProcessing,
    ScheduleListResponse? listData,
    ScheduleProposalEntity? detailData,
    String? errorMessage,
  }) {
    return ScheduleState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isProcessing: isProcessing ?? this.isProcessing,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
      errorMessage: errorMessage,
    );
  }
}
