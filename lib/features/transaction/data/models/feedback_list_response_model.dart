import 'package:GreenConnectMobile/features/offer/data/models/paginated_offer_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/feedback_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/feedback_list_response.dart';

class FeedbackListResponseModel {
  final List<FeedbackModel> data;
  final PaginationInfoModel pagination;

  FeedbackListResponseModel({
    required this.data,
    required this.pagination,
  });

  factory FeedbackListResponseModel.fromJson(Map<String, dynamic> json) {
    return FeedbackListResponseModel(
      data: (json['data'] as List)
          .map((e) => FeedbackModel.fromJson(e))
          .toList(),
      pagination: PaginationInfoModel.fromJson(json['pagination']),
    );
  }

  FeedbackListResponse toEntity() {
    return FeedbackListResponse(
      data: data.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}
