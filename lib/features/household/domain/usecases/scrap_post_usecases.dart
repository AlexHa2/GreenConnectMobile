import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/repository/scrap_post_repository.dart';

class CreateScrapPostUsecase {
  final ScrapPostRepository repository;
  CreateScrapPostUsecase(this.repository);

  Future<bool> call(ScrapPostEntity entity) {
    return repository.createScrapPost(entity);
  }
}
