import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class DeleteScrapDetailUsecase {
  final ScrapPostRepository repository;
  DeleteScrapDetailUsecase(this.repository);

  Future<bool> call({required String postId, required String categoryId}) {
    return repository.deleteScrapDetail(
      postId: postId,
      scrapCategoryId: categoryId,
    );
  }
}
