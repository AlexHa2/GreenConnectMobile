import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class CreateScrapDetailUsecase {
  final ScrapPostRepository repository;
  CreateScrapDetailUsecase(this.repository);

  Future<bool> call({
    required String postId,
    required ScrapPostDetailEntity detail,
  }) {
    return repository.createScrapDetail(postId: postId, detail: detail);
  }
}
