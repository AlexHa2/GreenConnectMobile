import 'package:GreenConnectMobile/features/package/domain/entities/pagination_entity.dart';

class PaginationModel extends PaginationEntity {
  PaginationModel({
    required super.totalRecords,
    required super.currentPage,
    required super.totalPages,
    super.nextPage,
    super.prevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      totalRecords: json['totalRecords'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
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

  PaginationEntity toEntity() {
    return PaginationEntity(
      totalRecords: totalRecords,
      currentPage: currentPage,
      totalPages: totalPages,
      nextPage: nextPage,
      prevPage: prevPage,
    );
  }
}
