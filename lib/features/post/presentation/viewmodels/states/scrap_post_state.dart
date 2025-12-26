import 'package:GreenConnectMobile/features/post/domain/entities/household_report_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/analyze_scrap_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart';

class ScrapPostState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isLoadingReport;
  final bool isAnalyzing;
  final bool isLoadingTransactions;
  
  // Separate loading states for update operations
  final bool isUpdatingPost;
  final bool isUpdatingDetail;
  final bool isUpdatingTimeSlot;
  
  // Progress tracking for AI analysis (0.0 to 1.0)
  final double analyzeProgress;
  
  final String? errorMessage;

  final PaginatedScrapPostEntity? listData;
  final ScrapPostEntity? detailData;
  final HouseholdReportEntity? reportData;
  final AnalyzeScrapResultEntity? analyzeResult;
  final PostTransactionsResponseEntity? transactionsData;

  ScrapPostState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isLoadingReport = false,
    this.isAnalyzing = false,
    this.isLoadingTransactions = false,
    this.isUpdatingPost = false,
    this.isUpdatingDetail = false,
    this.isUpdatingTimeSlot = false,
    this.analyzeProgress = 0.0,
    this.errorMessage,
    this.listData,
    this.detailData,
    this.reportData,
    this.analyzeResult,
    this.transactionsData,
  });

  ScrapPostState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isLoadingReport,
    bool? isAnalyzing,
    bool? isLoadingTransactions,
    bool? isUpdatingPost,
    bool? isUpdatingDetail,
    bool? isUpdatingTimeSlot,
    double? analyzeProgress,
    String? errorMessage,
    PaginatedScrapPostEntity? listData,
    ScrapPostEntity? detailData,
    HouseholdReportEntity? reportData,
    AnalyzeScrapResultEntity? analyzeResult,
    PostTransactionsResponseEntity? transactionsData,
  }) {
    return ScrapPostState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isLoadingReport: isLoadingReport ?? this.isLoadingReport,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      isLoadingTransactions: isLoadingTransactions ?? this.isLoadingTransactions,
      isUpdatingPost: isUpdatingPost ?? this.isUpdatingPost,
      isUpdatingDetail: isUpdatingDetail ?? this.isUpdatingDetail,
      isUpdatingTimeSlot: isUpdatingTimeSlot ?? this.isUpdatingTimeSlot,
      analyzeProgress: analyzeProgress ?? this.analyzeProgress,
      errorMessage: errorMessage,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
      reportData: reportData ?? this.reportData,
      analyzeResult: analyzeResult ?? this.analyzeResult,
      transactionsData: transactionsData ?? this.transactionsData,
    );
  }
}
