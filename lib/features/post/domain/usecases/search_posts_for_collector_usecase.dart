import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class SearchPostsForCollectorUsecase {
  final ScrapPostRepository repository;

  SearchPostsForCollectorUsecase(this.repository);

  Future<PaginatedScrapPostEntity> call({
    String? categoryId,
    String? categoryName,
    String? status,
    bool? sortByLocation,
    bool? sortByCreateAt,
    required int pageNumber,
    required int pageSize,
  }) {
    return repository.searchPostsForCollector(
      categoryId: categoryId,
      categoryName: categoryName,
      status: status,
      sortByLocation: sortByLocation,
      sortByCreateAt: sortByCreateAt,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
