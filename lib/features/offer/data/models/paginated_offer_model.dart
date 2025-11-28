import 'package:GreenConnectMobile/features/offer/data/models/collection_offer_model.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';

class PaginatedOfferModel {
  final List<CollectionOfferModel> data;
  final PaginationInfoModel pagination;

  PaginatedOfferModel({
    required this.data,
    required this.pagination,
  });

  factory PaginatedOfferModel.fromJson(Map<String, dynamic> json) {
    return PaginatedOfferModel(
      data: (json['data'] as List)
          .map((e) => CollectionOfferModel.fromJson(e))
          .toList(),
      pagination: PaginationInfoModel.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  PaginatedOfferEntity toEntity() {
    return PaginatedOfferEntity(
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
