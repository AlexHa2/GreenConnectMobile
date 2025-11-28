import 'package:GreenConnectMobile/core/common/paginate/paginate_entity.dart';
import 'package:GreenConnectMobile/core/common/paginate/paginate_model.dart';
import 'package:GreenConnectMobile/core/di/auth_injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/post/data/datasources/abstract_datasources/scrap_category_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_category/scrap_category_model.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';

class ScrapCategoryRemoteDataSourceImpl
  implements ScrapCategoryRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String _baseUrl = '/v1/scrap-categories';

  @override
  Future<PaginatedResponseEntity<ScrapCategoryEntity>> getScrapCategories({
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _apiClient.get(
      '$_baseUrl?pageNumber=$pageNumber&pageSize=$pageSize',
    );

    final result = PaginatedResponseModel.fromJson(
      response.data,
      (json) => ScrapCategoryModel.fromJson(json),
    );

    return result.toEntity((model) => model.toEntity());
  }

  @override
  Future<ScrapCategoryEntity> getScrapCategoryDetail(int id) async {
    final response = await _apiClient.get('$_baseUrl/$id');
    return ScrapCategoryModel.fromJson(response.data).toEntity();
  }
}
