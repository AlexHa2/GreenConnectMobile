import 'package:GreenConnectMobile/features/schedule/data/models/schedule_proposal_model.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_list_response.dart';

class ScheduleListResponseModel {
  final List<ScheduleProposalModel> data;
  final PaginationInfoModel pagination;

  ScheduleListResponseModel({
    required this.data,
    required this.pagination,
  });

  factory ScheduleListResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleListResponseModel(
      data: (json['data'] as List)
          .map((e) => ScheduleProposalModel.fromJson(e))
          .toList(),
      pagination: PaginationInfoModel.fromJson(json['pagination']),
    );
  }

  ScheduleListResponse toEntity() {
    return ScheduleListResponse(
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
      totalRecords: json['totalRecords'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );
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
