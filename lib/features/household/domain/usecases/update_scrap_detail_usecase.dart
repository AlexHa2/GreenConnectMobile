import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/repository/scrap_post_repository.dart';

class UpdateScrapDetailUsecase {
  final ScrapPostRepository repository;
  UpdateScrapDetailUsecase(this.repository);

  Future<bool> call({
    required String postId,
    required ScrapPostDetailEntity detail,
  }) {
    return repository.updateScrapDetail(postId: postId, detail: detail);
  }
}