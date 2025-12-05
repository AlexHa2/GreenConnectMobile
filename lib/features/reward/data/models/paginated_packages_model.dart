import 'package:GreenConnectMobile/features/reward/data/models/package_model.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/paginated_packages_entity.dart';

class PaginationModel extends PaginationEntity {
  PaginationModel({
    required super.totalRecords,
    required super.currentPage,
    required super.totalPages,
    required super.nextPage,
    required super.prevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      totalRecords: json['totalRecords'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      nextPage: json['nextPage'] ?? 0,
      prevPage: json['prevPage'] ?? 0,
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

class PaginatedPackagesModel extends PaginatedPackagesEntity {
  PaginatedPackagesModel({
    required super.data,
    required super.pagination,
  });

  factory PaginatedPackagesModel.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>?)
            ?.map((item) => PackageModel.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    final paginationData = json['pagination'] != null
        ? PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>)
        : PaginationModel(
            totalRecords: 0,
            currentPage: 0,
            totalPages: 0,
            nextPage: 0,
            prevPage: 0,
          );

    return PaginatedPackagesModel(
      data: dataList,
      pagination: paginationData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => (item as PackageModel).toJson()).toList(),
      'pagination': (pagination as PaginationModel).toJson(),
    };
  }

  PaginatedPackagesEntity toEntity() {
    return PaginatedPackagesEntity(
      data: data.map((item) => (item as PackageModel).toEntity()).toList(),
      pagination: (pagination as PaginationModel).toEntity(),
    );
  }
}
