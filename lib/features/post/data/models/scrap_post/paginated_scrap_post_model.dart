// paginated_scrap_post_model.dart
import 'package:GreenConnectMobile/core/common/paginate/paginate_entity.dart';
import 'package:GreenConnectMobile/core/common/paginate/paginate_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_model.dart';

class PaginatedScrapPostModel extends PaginatedResponseModel<ScrapPostModel> {
  PaginatedScrapPostModel({required super.data, required super.pagination});

  /// Parse JSON -> Model
  factory PaginatedScrapPostModel.fromJson(Map<String, dynamic> json) {
    return PaginatedScrapPostModel(
      data: (json['data'] as List)
          .map((e) => ScrapPostModel.fromJson(e))
          .toList(),
      pagination: PaginationEntity(
        totalRecords: json['pagination']['totalRecords'] ?? 0,
        currentPage: json['pagination']['currentPage'] ?? 1,
        totalPages: json['pagination']['totalPages'] ?? 1,
        nextPage: json['pagination']['nextPage'],
        prevPage: json['pagination']['prevPage'],
      ),
    );
  }
}
