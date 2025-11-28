import 'package:GreenConnectMobile/features/offer/data/models/paginated_offer_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_list_response.dart';

class TransactionListResponseModel {
  final List<TransactionModel> data;
  final PaginationInfoModel pagination;

  TransactionListResponseModel({
    required this.data,
    required this.pagination,
  });

  factory TransactionListResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionListResponseModel(
      data: (json['data'] as List)
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
      pagination: PaginationInfoModel.fromJson(json['pagination']),
    );
  }

  TransactionListResponse toEntity() {
    return TransactionListResponse(
      data: data.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}
