import 'package:GreenConnectMobile/core/common/paginate/paginate_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';

abstract class ScrapCategoryRemoteDataSource {
  Future<PaginatedResponseEntity<ScrapCategoryEntity>> getScrapCategories({
    required int pageNumber,
    required int pageSize,
  });

  Future<ScrapCategoryEntity> getScrapCategoryDetail(int id);
}
