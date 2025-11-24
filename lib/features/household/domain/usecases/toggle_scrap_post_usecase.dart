import 'package:GreenConnectMobile/features/household/domain/repository/scrap_post_repository.dart';

class ToggleScrapPostUsecase {
  final ScrapPostRepository repository;
  ToggleScrapPostUsecase(this.repository);

  Future<bool> call(String postId) {
    return repository.toggleScrapPost(postId);
  }
}

