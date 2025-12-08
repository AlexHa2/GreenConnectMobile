import 'package:GreenConnectMobile/features/package/data/models/package_model.dart';
import 'package:GreenConnectMobile/features/package/data/models/pagination_model.dart';
import 'package:GreenConnectMobile/features/package/domain/entities/package_list_response_entity.dart';

class PackageListResponseModel extends PackageListResponseEntity {
  PackageListResponseModel({
    required super.data,
    required super.pagination,
  });

  factory PackageListResponseModel.fromJson(Map<String, dynamic> json) {
    return PackageListResponseModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => PackageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(
          json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => (e as PackageModel).toJson()).toList(),
      'pagination': (pagination as PaginationModel).toJson(),
    };
  }

  PackageListResponseEntity toEntity() {
    return PackageListResponseEntity(
      data: data.map((e) => (e as PackageModel).toEntity()).toList(),
      pagination: (pagination as PaginationModel).toEntity(),
    );
  }
}
