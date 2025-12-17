import 'package:GreenConnectMobile/features/post/domain/entities/household_report_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';

class ScrapPostState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isLoadingReport;
  final String? errorMessage;

  final PaginatedScrapPostEntity? listData;
  final ScrapPostEntity? detailData;
  final HouseholdReportEntity? reportData;

  ScrapPostState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isLoadingReport = false,
    this.errorMessage,
    this.listData,
    this.detailData,
    this.reportData,
  });

  ScrapPostState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isLoadingReport,
    String? errorMessage,
    PaginatedScrapPostEntity? listData,
    ScrapPostEntity? detailData,
    HouseholdReportEntity? reportData,
  }) {
    return ScrapPostState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isLoadingReport: isLoadingReport ?? this.isLoadingReport,
      errorMessage: errorMessage,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
      reportData: reportData ?? this.reportData,
    );
  }
}
