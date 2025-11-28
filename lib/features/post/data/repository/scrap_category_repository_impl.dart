import 'package:GreenConnectMobile/core/common/paginate/paginate_entity.dart';
import 'package:GreenConnectMobile/features/post/data/datasources/abstract_datasources/scrap_category_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/datasources/scrap_category_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_category_repository.dart';

class ScrapCategoryRepositoryImpl implements ScrapCategoryRepository {
  final ScrapCategoryRemoteDataSource _remoteDataSource;
  ScrapCategoryRepositoryImpl({
    required ScrapCategoryRemoteDataSourceImpl remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<PaginatedResponseEntity<ScrapCategoryEntity>> getScrapCategories({
    required int pageNumber,
    required int pageSize,
  }) {
    return _remoteDataSource.getScrapCategories(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  @override
  Future<ScrapCategoryEntity> getScrapCategoryDetail(int id) {
    return _remoteDataSource.getScrapCategoryDetail(id);
  }
}
