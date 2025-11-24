import 'package:GreenConnectMobile/features/household/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/update_scrap_post_entity.dart';

abstract class ScrapPostRepository {
  Future<bool> createScrapPost(ScrapPostEntity post);

  Future<PaginatedScrapPostEntity> getMyPosts({
    String? title,
    String? status,
    required int pageNumber,
    required int pageSize,
  });

  Future<ScrapPostEntity> getPostDetail(String postId);

  Future<bool> updateScrapPost(UpdateScrapPostEntity entity);

  Future<bool> toggleScrapPost(String postId);

  Future<bool> createScrapDetail({
    required String postId,
    required ScrapPostDetailEntity detail,
  });

  Future<bool> updateScrapDetail({
    required String postId,
    required ScrapPostDetailEntity detail,
  });

  Future<bool> deleteScrapDetail({
    required String postId,
    required int
    scrapCategoryId,
  });
}
