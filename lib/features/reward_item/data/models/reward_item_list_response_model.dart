import 'package:GreenConnectMobile/features/reward_item/data/models/reward_item_model.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_list_response.dart';

class RewardItemListResponseModel {
  final List<RewardItemModel> data;
  final PaginationInfoModel pagination;

  RewardItemListResponseModel({
    required this.data,
    required this.pagination,
  });

  factory RewardItemListResponseModel.fromJson(Map<String, dynamic> json) {
    return RewardItemListResponseModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => RewardItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationInfoModel.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  RewardItemListResponse toEntity() {
    return RewardItemListResponse(
      data: data.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}

class PaginationInfoModel {
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginationInfoModel({
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });

  factory PaginationInfoModel.fromJson(Map<String, dynamic> json) {
    return PaginationInfoModel(
      totalRecords: json['totalRecords'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRecords': totalRecords,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'nextPage': nextPage,
      'prevPage': prevPage,
    };
  }

  PaginationInfo toEntity() {
    return PaginationInfo(
      totalRecords: totalRecords,
      currentPage: currentPage,
      totalPages: totalPages,
      nextPage: nextPage,
      prevPage: prevPage,
    );
  }
}
