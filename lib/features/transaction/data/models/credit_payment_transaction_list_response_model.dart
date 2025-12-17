import 'package:GreenConnectMobile/features/offer/data/models/paginated_offer_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/credit_transaction_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/payment_transaction_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/credit_transaction_list_response.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/payment_transaction_list_response.dart';

class CreditTransactionListResponseModel {
  final List<CreditTransactionModel> data;
  final PaginationInfoModel pagination;

  CreditTransactionListResponseModel({
    required this.data,
    required this.pagination,
  });

  factory CreditTransactionListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreditTransactionListResponseModel(
      data: (json['data'] as List)
          .map((e) => CreditTransactionModel.fromJson(e))
          .toList(),
      pagination: PaginationInfoModel.fromJson(json['pagination']),
    );
  }

  CreditTransactionListResponse toEntity() {
    return CreditTransactionListResponse(
      data: data.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}

class PaymentTransactionListResponseModel {
  final List<PaymentTransactionModel> data;
  final PaginationInfoModel pagination;

  PaymentTransactionListResponseModel({
    required this.data,
    required this.pagination,
  });

  factory PaymentTransactionListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentTransactionListResponseModel(
      data: (json['data'] as List)
          .map((e) => PaymentTransactionModel.fromJson(e))
          .toList(),
      pagination: PaginationInfoModel.fromJson(json['pagination']),
    );
  }

  PaymentTransactionListResponse toEntity() {
    return PaymentTransactionListResponse(
      data: data.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}
