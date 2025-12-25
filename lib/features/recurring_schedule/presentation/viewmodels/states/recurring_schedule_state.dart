import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/paginated_recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';

class RecurringScheduleState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isLoadingMutation;
  final String? errorMessage;

  final PaginatedRecurringScheduleEntity? listData;
  final RecurringScheduleEntity? detailData;
  final RecurringScheduleDetailEntity? detailItem;

  const RecurringScheduleState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isLoadingMutation = false,
    this.errorMessage,
    this.listData,
    this.detailData,
    this.detailItem,
  });

  RecurringScheduleState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isLoadingMutation,
    String? errorMessage,
    PaginatedRecurringScheduleEntity? listData,
    RecurringScheduleEntity? detailData,
    RecurringScheduleDetailEntity? detailItem,
  }) {
    return RecurringScheduleState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isLoadingMutation: isLoadingMutation ?? this.isLoadingMutation,
      errorMessage: errorMessage,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
      detailItem: detailItem ?? this.detailItem,
    );
  }
}

