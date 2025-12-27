import 'dart:typed_data';

import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/post/data/datasources/abstract_datasources/scrap_post_remote_datasource.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/create_scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/location_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/analyze_scrap_result_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_detail_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/update_scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/analyze_scrap_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/household_report_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart';
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
        availableTimeRange: post.availableTimeRange ?? '',
        location: LocationModel.fromEntity(post.location!),
        mustTakeAll: post.mustTakeAll,
        scrapPostDetails: post.scrapPostDetails.map((d) {
          return CreateScrapPostDetailModel(
            scrapCategoryId: d.scrapCategoryId,
            amountDescription: d.amountDescription,
            imageUrl: d.imageUrl,
            type: d.type,
          );
        }).toList(),
        scrapPostTimeSlots: post.scrapPostTimeSlots.map((t) {
          return CreateScrapPostTimeSlotModel(
            specificDate: t.specificDate,
            startTime: t.startTime,
            endTime: t.endTime,
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
        type: detail.type,
      );

      return await remote.createScrapDetail(postId: postId, detail: model);
    });
  }

  @override
  Future<bool> deleteScrapDetail({
    required String postId,
    required String scrapCategoryId,
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
        type: detail.type,
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
    String? categoryId,
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

  @override
  Future<AnalyzeScrapResultEntity> analyzeScrap({
    required Uint8List imageBytes,
    required String fileName,
    void Function(int sent, int total, double progress)? onProgress,
    int maxRetries = 3,
  }) {
    return guard(() async {
      final AnalyzeScrapResultModel result = await remote.analyzeScrap(
        imageBytes: imageBytes,
        fileName: fileName,
        onProgress: onProgress,
        maxRetries: maxRetries,
      );
      return result.toEntity();
    });
  }

  @override
  Future<ScrapPostTimeSlotEntity> createTimeSlot({
    required String postId,
    required String specificDate,
    required String startTime,
    required String endTime,
  }) {
    return guard(() async {
      final result = await remote.createTimeSlot(
        postId: postId,
        specificDate: specificDate,
        startTime: startTime,
        endTime: endTime,
      );
      return result.toEntity();
    });
  }

  @override
  Future<ScrapPostTimeSlotEntity> updateTimeSlot({
    required String postId,
    required String timeSlotId,
    required String specificDate,
    required String startTime,
    required String endTime,
  }) {
    return guard(() async {
      final result = await remote.updateTimeSlot(
        postId: postId,
        timeSlotId: timeSlotId,
        specificDate: specificDate,
        startTime: startTime,
        endTime: endTime,
      );
      return result.toEntity();
    });
  }

  @override
  Future<bool> deleteTimeSlot({
    required String postId,
    required String timeSlotId,
  }) {
    return guard(() async {
      return await remote.deleteTimeSlot(
        postId: postId,
        timeSlotId: timeSlotId,
      );
    });
  }

  @override
  Future<PostTransactionsResponseEntity> getPostTransactions({
    required String postId,
    required String collectorId,
    required String slotId,
  }) {
    return guard(() async {
      final result = await remote.getPostTransactions(
        postId: postId,
        collectorId: collectorId,
        slotId: slotId,
      );
      return result.toEntity();
    });
  }
}
