import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_category_repository.dart';

class GetScrapCategoryDetailUseCase {
  final ScrapCategoryRepository _repository;

  GetScrapCategoryDetailUseCase({required ScrapCategoryRepository repository})
    : _repository = repository;
    
  Future<ScrapCategoryEntity> call(int id) {
    return _repository.getScrapCategoryDetail(id);
  }
}
