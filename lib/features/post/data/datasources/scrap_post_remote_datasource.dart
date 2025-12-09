import 'package:GreenConnectMobile/core/di/auth_injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/post/data/datasources/abstract_datasources/scrap_post_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/create_scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/household_report_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/paginated_scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_detail_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/update_scrap_post_model.dart';

class ScrapPostRemoteDataSourceImpl implements ScrapPostRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String _baseUrl = '/v1/posts';
  final String _reportUrl = '/v1/reports';
  @override
  Future<bool> createScrapPost(CreateScrapPostModel model) async {
    final res = await _apiClient.post(_baseUrl, data: model.toJson());
    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }

  @override
  Future<PaginatedScrapPostModel> getMyPosts({
    String? title,
    String? status,
    required int pageNumber,
    required int pageSize,
  }) async {
    final res = await _apiClient.get(
      '$_baseUrl/my-posts',
      queryParameters: {
        "title": title,
        "status": status,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      },
    );
    return PaginatedScrapPostModel.fromJson(res.data);
  }

  @override
  Future<ScrapPostModel> getPostDetail(String postId) async {
    final res = await _apiClient.get('$_baseUrl/$postId');
    return ScrapPostModel.fromJson(res.data);
  }

  @override
  Future<bool> createScrapDetail({
    required String postId,
    required ScrapPostDetailModel detail,
  }) async {
    final res = await _apiClient.post(
      '$_baseUrl/$postId/details',
      data: detail.toJson(),
    );
    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteScrapDetail({
    required String postId,
    required int scrapCategoryId,
  }) async {
    final res = await _apiClient.delete(
      '$_baseUrl/$postId/details/$scrapCategoryId',
    );
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> toggleScrapPost(String postId) async {
    final res = await _apiClient.patch('$_baseUrl/$postId/toggle');
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateScrapDetail({
    required String postId,
    required ScrapPostDetailModel detail,
  }) async {
    final res = await _apiClient.put(
      '$_baseUrl/$postId/details/${detail.scrapCategoryId}',
      data: detail.toJson(),
    );
    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  @override
  Future<bool> updateScrapPost(UpdateScrapPostModel model) async {
    final res = await _apiClient.put(
      '$_baseUrl/${model.scrapPostId}',
      data: model.toJson(),
    );
    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  @override
  Future<PaginatedScrapPostModel> searchPostsForCollector({
    String? categoryName,
    String? status,
    bool? sortByLocation,
    bool? sortByCreateAt,
    required int pageNumber,
    required int pageSize,
  }) async {
    final res = await _apiClient.get(
      _baseUrl,
      queryParameters: {
        if (categoryName != null && categoryName.isNotEmpty)
          "categoryName": categoryName,
        if (status != null && status.isNotEmpty) "status": status,
        if (sortByLocation != null) "sortByLocation": sortByLocation,
        if (sortByCreateAt != null) "sortByCreateAt": sortByCreateAt,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      },
    );
    return PaginatedScrapPostModel.fromJson(res.data);
  }

  @override
  Future<HouseholdReportModel> getHouseholdReport({
    required String start,
    required String end,
  }) async {
    final res = await _apiClient.get(
      '$_reportUrl/household',
      queryParameters: {
        'start': start,
        'end': end,
      },
    );
    return HouseholdReportModel.fromJson(res.data);
  }
}
