import 'package:GreenConnectMobile/features/post/data/models/scrap_post/create_scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/household_report_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/paginated_scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_detail_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/update_scrap_post_model.dart';

abstract class ScrapPostRemoteDataSource {
  Future<bool> createScrapPost(CreateScrapPostModel post);

  Future<PaginatedScrapPostModel> getMyPosts({
    String? title,
    String? status,
    required int pageNumber,
    required int pageSize,
  });

  Future<ScrapPostModel> getPostDetail(String postId);

  Future<bool> updateScrapPost(UpdateScrapPostModel model);

  Future<bool> toggleScrapPost(String postId);

  Future<bool> createScrapDetail({
    required String postId,
    required ScrapPostDetailModel detail,
  });

  Future<bool> updateScrapDetail({
    required String postId,
    required ScrapPostDetailModel detail,
  });

  Future<bool> deleteScrapDetail({
    required String postId,
    required int scrapCategoryId,
  });

  Future<PaginatedScrapPostModel> searchPostsForCollector({
    int? categoryId,
    String? categoryName,
    String? status,
    bool? sortByLocation,
    bool? sortByCreateAt,
    required int pageNumber,
    required int pageSize,
  });

  Future<HouseholdReportModel> getHouseholdReport({
    required String start,
    required String end,
  });
}
