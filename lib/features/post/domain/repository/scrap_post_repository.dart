import 'dart:typed_data';

import 'package:GreenConnectMobile/features/post/domain/entities/household_report_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/paginated_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/analyze_scrap_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/update_scrap_post_entity.dart';

abstract class ScrapPostRepository {
  Future<bool> createScrapPost(ScrapPostEntity post);

  Future<PaginatedScrapPostEntity> getMyPosts({
    String? title,
    String? status,
    required int pageNumber,
    required int pageSize,
  });

  Future<ScrapPostEntity> getPostDetail(String postId);

  Future<bool> updateScrapPost(UpdateScrapPostEntity entity);

  Future<bool> toggleScrapPost(String postId);

  Future<bool> createScrapDetail({
    required String postId,
    required ScrapPostDetailEntity detail,
  });

  Future<bool> updateScrapDetail({
    required String postId,
    required ScrapPostDetailEntity detail,
  });

  Future<bool> deleteScrapDetail({
    required String postId,
    required String scrapCategoryId,
  });

  Future<PaginatedScrapPostEntity> searchPostsForCollector({
    String? categoryId,
    String? categoryName,
    String? status,
    bool? sortByLocation,
    bool? sortByCreateAt,
    required int pageNumber,
    required int pageSize,
  });

  Future<HouseholdReportEntity> getHouseholdReport({
    required String start,
    required String end,
  });

  Future<AnalyzeScrapResultEntity> analyzeScrap({
    required Uint8List imageBytes,
    required String fileName,
  });

  Future<ScrapPostTimeSlotEntity> createTimeSlot({
    required String postId,
    required String specificDate,
    required String startTime,
    required String endTime,
  });

  Future<ScrapPostTimeSlotEntity> updateTimeSlot({
    required String postId,
    required String timeSlotId,
    required String specificDate,
    required String startTime,
    required String endTime,
  });

  Future<bool> deleteTimeSlot({
    required String postId,
    required String timeSlotId,
  });
}
