import 'package:GreenConnectMobile/core/common/paginate/paginate_entity.dart';

class PaginatedResponseModel<T> {
  final List<T> data;
  final PaginationEntity pagination;

  PaginatedResponseModel({required this.data, required this.pagination});

  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponseModel(
      data: (json['data'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationEntity(
        totalRecords: json['pagination']['totalRecords'],
        currentPage: json['pagination']['currentPage'],
        totalPages: json['pagination']['totalPages'],
        nextPage: json['pagination']['nextPage'],
        prevPage: json['pagination']['prevPage'],
      ),
    );
  }

  /// ▶️ Convert Model -> JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'data': data.map((e) => toJsonT(e)).toList(),
      'pagination': {
        'totalRecords': pagination.totalRecords,
        'currentPage': pagination.currentPage,
        'totalPages': pagination.totalPages,
        'nextPage': pagination.nextPage,
        'prevPage': pagination.prevPage,
      },
    };
  }

  /// 🔁 Convert Model -> Entity
  PaginatedResponseEntity<E> toEntity<E>(E Function(T) mapper) {
    return PaginatedResponseEntity<E>(
      data: data.map((e) => mapper(e)).toList(),
      pagination: pagination,
    );
  }
}
