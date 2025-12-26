import 'package:GreenConnectMobile/features/post/domain/entities/household_report_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/analyze_scrap_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';

class ScrapPostState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isLoadingReport;
  final bool isAnalyzing;
  
  // Separate loading states for update operations
  final bool isUpdatingPost;
  final bool isUpdatingDetail;
  final bool isUpdatingTimeSlot;
  
  final String? errorMessage;

  final PaginatedScrapPostEntity? listData;
  final ScrapPostEntity? detailData;
  final HouseholdReportEntity? reportData;
  final AnalyzeScrapResultEntity? analyzeResult;

  ScrapPostState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isLoadingReport = false,
    this.isAnalyzing = false,
    this.isUpdatingPost = false,
    this.isUpdatingDetail = false,
    this.isUpdatingTimeSlot = false,
    this.errorMessage,
    this.listData,
    this.detailData,
    this.reportData,
    this.analyzeResult,
  });

  ScrapPostState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isLoadingReport,
    bool? isAnalyzing,
    bool? isUpdatingPost,
    bool? isUpdatingDetail,
    bool? isUpdatingTimeSlot,
    String? errorMessage,
    PaginatedScrapPostEntity? listData,
    ScrapPostEntity? detailData,
    HouseholdReportEntity? reportData,
    AnalyzeScrapResultEntity? analyzeResult,
  }) {
    return ScrapPostState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isLoadingReport: isLoadingReport ?? this.isLoadingReport,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      isUpdatingPost: isUpdatingPost ?? this.isUpdatingPost,
      isUpdatingDetail: isUpdatingDetail ?? this.isUpdatingDetail,
      isUpdatingTimeSlot: isUpdatingTimeSlot ?? this.isUpdatingTimeSlot,
      errorMessage: errorMessage,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
      reportData: reportData ?? this.reportData,
      analyzeResult: analyzeResult ?? this.analyzeResult,
    );
  }
}
