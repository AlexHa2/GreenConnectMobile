import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/post/data/datasources/abstract_datasources/scrap_post_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/create_scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/location_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_detail_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/update_scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/household_report_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/update_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/repository/scrap_post_repository.dart';

class ScrapPostRepositoryImpl implements ScrapPostRepository {
  final ScrapPostRemoteDataSource remote;

  ScrapPostRepositoryImpl(this.remote);

  @override
  Future<bool> createScrapPost(ScrapPostEntity post) {
    return guard(() async {
      final model = CreateScrapPostModel(
        title: post.title,
        description: post.description,
        address: post.address,
        availableTimeRange: post.availableTimeRange,
        location: LocationModel.fromEntity(post.location),
        mustTakeAll: post.mustTakeAll,
        scrapPostDetails: post.scrapPostDetails.map((d) {
          return CreateScrapPostDetailModel(
            scrapCategoryId: d.scrapCategoryId,
            amountDescription: d.amountDescription,
            imageUrl: d.imageUrl,
          );
        }).toList(),
      );

      final response = await remote.createScrapPost(model);
      if (response) {
        return true;
      }
      return false;
    });
  }

  @override
  Future<PaginatedScrapPostEntity> getMyPosts({
    String? title,
    String? status,
    required int pageNumber,
    required int pageSize,
  }) {
    return guard(() async {
      final result = await remote.getMyPosts(
        title: title,
        status: status,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      return result.toEntity((model) => model.toEntity());
    });
  }

  @override
  Future<ScrapPostEntity> getPostDetail(String postId) {
    return guard(() async {
      final result = await remote.getPostDetail(postId);
      return result.toEntity();
    });
  }

  @override
  Future<bool> createScrapDetail({
    required String postId,
    required ScrapPostDetailEntity detail,
  }) {
    return guard(() async {
      final model = ScrapPostDetailModel(
        scrapCategoryId: detail.scrapCategoryId,
        amountDescription: detail.amountDescription,
        imageUrl: detail.imageUrl,
      );

      return await remote.createScrapDetail(postId: postId, detail: model);
    });
  }

  @override
  Future<bool> deleteScrapDetail({
    required String postId,
    required int scrapCategoryId,
  }) {
    return guard(() async {
      return await remote.deleteScrapDetail(
        postId: postId,
        scrapCategoryId: scrapCategoryId,
      );
    });
  }

  @override
  Future<bool> toggleScrapPost(String postId) {
    return guard(() async {
      return await remote.toggleScrapPost(postId);
    });
  }

  @override
  Future<bool> updateScrapDetail({
    required String postId,
    required ScrapPostDetailEntity detail,
  }) {
    return guard(() async {
      final model = ScrapPostDetailModel(
        scrapCategoryId: detail.scrapCategoryId,
        amountDescription: detail.amountDescription,
        imageUrl: detail.imageUrl,
        status: detail.status,
      );

      return await remote.updateScrapDetail(postId: postId, detail: model);
    });
  }

  @override
  Future<bool> updateScrapPost(UpdateScrapPostEntity entity) {
    return guard(() async {
      final model = UpdateScrapPostModel(
        scrapPostId: entity.scrapPostId,
        title: entity.title,
        description: entity.description,
        address: entity.address,
        availableTimeRange: entity.availableTimeRange,
        mustTakeAll: entity.mustTakeAll,
        location: LocationUpdateModel(
          longitude: entity.location.longitude,
          latitude: entity.location.latitude,
        ),
      );

      return await remote.updateScrapPost(model);
    });
  }

  @override
  Future<PaginatedScrapPostEntity> searchPostsForCollector({
    int? categoryId,
    String? categoryName,
    String? status,
    bool? sortByLocation,
    bool? sortByCreateAt,
    required int pageNumber,
    required int pageSize,
  }) {
    return guard(() async {
      final result = await remote.searchPostsForCollector(
        categoryId: categoryId,
        categoryName: categoryName,
        status: status,
        sortByLocation: sortByLocation,
        sortByCreateAt: sortByCreateAt,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return result.toEntity((model) => model.toEntity());
    });
  }

  @override
  Future<HouseholdReportEntity> getHouseholdReport({
    required String start,
    required String end,
  }) {
    return guard(() async {
      final result = await remote.getHouseholdReport(
        start: start,
        end: end,
      );
      return result.toEntity();
    });
  }
}
