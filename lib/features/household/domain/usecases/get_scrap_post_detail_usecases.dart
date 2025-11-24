import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/repository/scrap_post_repository.dart';

class GetScrapPostDetailUsecase {
  final ScrapPostRepository repository;
  GetScrapPostDetailUsecase(this.repository);

  Future<ScrapPostEntity> call(String postId) {
    return repository.getPostDetail(postId);
  }
}

