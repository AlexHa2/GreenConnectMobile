import 'package:GreenConnectMobile/features/household/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/repository/scrap_post_repository.dart';

class GetMyScrapPostsUsecase {
  final ScrapPostRepository repository;
  GetMyScrapPostsUsecase(this.repository);

  Future<PaginatedScrapPostEntity> call({
    String? title,
    String? status,
    required int page,
    required int size,
  }) {
    return repository.getMyPosts(
      title: title,
      status: status,
      pageNumber: page,
      pageSize: size,
    );
  }
}