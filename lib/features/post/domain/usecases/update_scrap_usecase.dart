import 'package:GreenConnectMobile/features/post/domain/entities/update_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class UpdateScrapPostUsecase {
  final ScrapPostRepository repository;
  UpdateScrapPostUsecase(this.repository);

  Future<bool> call(UpdateScrapPostEntity entity) {
    return repository.updateScrapPost(entity);
  }
}
