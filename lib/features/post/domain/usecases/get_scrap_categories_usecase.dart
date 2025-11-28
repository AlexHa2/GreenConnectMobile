import 'package:GreenConnectMobile/core/common/paginate/paginate_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_category_repository.dart';

class GetScrapCategoriesUseCase {
  final ScrapCategoryRepository _repository;
  GetScrapCategoriesUseCase({required ScrapCategoryRepository repository})
    : _repository = repository;

  Future<PaginatedResponseEntity<ScrapCategoryEntity>> call({
    required int pageNumber,
    required int pageSize,
  }) {
    return _repository.getScrapCategories(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
