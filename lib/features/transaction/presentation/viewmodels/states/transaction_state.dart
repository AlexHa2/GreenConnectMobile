import 'package:GreenConnectMobile/features/transaction/domain/entities/feedback_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_list_response.dart';

class TransactionState {
  final bool isLoadingList;
  final bool isLoadingDetail;
  final bool isProcessing; // for check-in, update details, process, toggle cancel
  final TransactionListResponse? listData;
  final TransactionEntity? detailData;
  final FeedbackListResponse? feedbackData;
  final String? errorMessage;
  final int? errorCode;

  TransactionState({
    this.isLoadingList = false,
    this.isLoadingDetail = false,
    this.isProcessing = false,
    this.listData,
    this.detailData,
    this.feedbackData,
    this.errorMessage,
    this.errorCode,
  });

  TransactionState copyWith({
    bool? isLoadingList,
    bool? isLoadingDetail,
    bool? isProcessing,
    TransactionListResponse? listData,
    TransactionEntity? detailData,
    FeedbackListResponse? feedbackData,
    String? errorMessage,
    int? errorCode,
  }) {
    return TransactionState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isProcessing: isProcessing ?? this.isProcessing,
      listData: listData ?? this.listData,
      detailData: detailData ?? this.detailData,
      feedbackData: feedbackData ?? this.feedbackData,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
