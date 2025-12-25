import 'dart:typed_data';

import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/analyze_scrap_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/update_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/analyze_scrap_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/create_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/create_time_slot_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/delete_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/delete_time_slot_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_household_report_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_my_scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/get_scrap_post_detail_usecases.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/search_posts_for_collector_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/toggle_scrap_post_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/update_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/update_scrap_usecase.dart';
import 'package:GreenConnectMobile/features/post/domain/usecases/update_time_slot_usecase.dart';
import 'package:GreenConnectMobile/features/post/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/post/presentation/viewmodels/states/scrap_post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrapPostViewModel extends Notifier<ScrapPostState> {
  late GetMyScrapPostsUsecase _getMyPosts;
  late GetScrapPostDetailUsecase _getDetail;
  late CreateScrapPostUsecase _createPost;
  late UpdateScrapPostUsecase _updatePost;
  late ToggleScrapPostUsecase _togglePost;
  late UpdateScrapDetailUsecase _updateDetail;
  late DeleteScrapDetailUsecase _deleteDetail;
  late CreateScrapDetailUsecase _createDetail;
  late SearchPostsForCollectorUsecase _searchPostsForCollector;
  late GetHouseholdReportUsecase _getHouseholdReport;
  late AnalyzeScrapUsecase _analyzeScrap;
  late CreateTimeSlotUsecase _createTimeSlot;
  late UpdateTimeSlotUsecase _updateTimeSlot;
  late DeleteTimeSlotUsecase _deleteTimeSlot;
  @override
  ScrapPostState build() {
    _getMyPosts = ref.read(getMyScrapPostsUsecaseProvider);
    _getDetail = ref.read(getScrapPostDetailUsecaseProvider);
    _createPost = ref.read(createScrapPostUsecaseProvider);
    _updatePost = ref.read(updateScrapPostUsecaseProvider);
    _togglePost = ref.read(toggleScrapPostUsecaseProvider);
    _updateDetail = ref.read(updateScrapDetailUsecaseProvider);
    _deleteDetail = ref.read(deleteScrapDetailUsecaseProvider);
    _createDetail = ref.read(createScrapDetailUsecaseProvider);
    _searchPostsForCollector = ref.read(searchPostsForCollectorUsecaseProvider);
    _getHouseholdReport = ref.read(getHouseholdReportUsecaseProvider);
    _analyzeScrap = ref.read(analyzeScrapUsecaseProvider);
    _createTimeSlot = ref.read(createTimeSlotUsecaseProvider);
    _updateTimeSlot = ref.read(updateTimeSlotUsecaseProvider);
    _deleteTimeSlot = ref.read(deleteTimeSlotUsecaseProvider);
    return ScrapPostState();
  }

  /// Fetch My Posts
  Future<void> fetchMyPosts({
    required int page,
    required int size,
    String? title,
    String? status,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _getMyPosts(
        page: page,
        size: size,
        title: title,
        status: status,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH MY POSTS SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }

  /// Search Posts For Collector
  Future<void> searchPostsForCollector({
    required int page,
    required int size,
    String? categoryId,
    String? categoryName,
    String? status,
    bool? sortByLocation,
    bool? sortByCreateAt,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _searchPostsForCollector(
        categoryId: categoryId,
        categoryName: categoryName,
        status: status,
        sortByLocation: sortByLocation,
        sortByCreateAt: sortByCreateAt,
        pageNumber: page,
        pageSize: size,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR SEARCH POSTS FOR COLLECTOR: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }

  /// Fetch Detail
  Future<void> fetchDetail(String postId) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);

    try {
      final result = await _getDetail(postId);
      state = state.copyWith(isLoadingDetail: false, detailData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH MY POSTS SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Create Post
  Future<bool> createPost({required ScrapPostEntity post}) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);

    try {
      await _createPost(post);

      state = state.copyWith(isLoadingDetail: false);
      return true;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH MY POSTS SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Update Post
  Future<bool> updatePost({
    required UpdateScrapPostEntity post,
    bool refreshDetail = true,
  }) async {
    state = state.copyWith(isUpdatingPost: true, errorMessage: null);
    try {
      await _updatePost(post);

      // Auto refresh detail data after successful update
      if (refreshDetail && state.detailData?.scrapPostId != null) {
        await fetchDetail(state.detailData!.scrapPostId!);
      }

      state = state.copyWith(isUpdatingPost: false);
      return true;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE POST SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isUpdatingPost: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Delete (or Toggle) Post
  Future<bool> deletePost(String postId) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);
    try {
      await _togglePost(postId);

      state = state.copyWith(isLoadingDetail: false);
      return true;
    } catch (e) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE POST SYSTEM: ${e.message}');
      }
      debugPrint('❌ ERROR DELETE POST: $e');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Create Detail
  Future<bool> createDetail({
    required String postId,
    required ScrapPostDetailEntity detail,
    bool refreshDetail = true,
  }) async {
    state = state.copyWith(isUpdatingDetail: true, errorMessage: null);
    try {
      await _createDetail(postId: postId, detail: detail);

      // Auto refresh detail data after successful create
      if (refreshDetail) {
        await fetchDetail(postId);
      }

      state = state.copyWith(isUpdatingDetail: false);
      return true;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR CREATE DETAIL SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isUpdatingDetail: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Update Detail
  Future<bool> updateDetail({
    required String postId,
    required ScrapPostDetailEntity detail,
    bool refreshDetail = true,
  }) async {
    state = state.copyWith(isUpdatingDetail: true, errorMessage: null);
    try {
      await _updateDetail(postId: postId, detail: detail);

      // Auto refresh detail data after successful update
      if (refreshDetail) {
        await fetchDetail(postId);
      }

      state = state.copyWith(isUpdatingDetail: false);
      return true;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE DETAIL SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isUpdatingDetail: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Delete Detail
  Future<bool> deleteDetail({
    required String postId,
    required String categoryId,
    bool refreshDetail = true,
  }) async {
    state = state.copyWith(isUpdatingDetail: true, errorMessage: null);
    try {
      await _deleteDetail(postId: postId, categoryId: categoryId);

      // Auto refresh detail data after successful delete
      if (refreshDetail) {
        await fetchDetail(postId);
      }

      state = state.copyWith(isUpdatingDetail: false);
      return true;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR DELETE DETAIL SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isUpdatingDetail: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Fetch Household Report
  Future<void> fetchHouseholdReport({
    required String start,
    required String end,
  }) async {
    state = state.copyWith(isLoadingReport: true, errorMessage: null);

    try {
      final result = await _getHouseholdReport(
        start: start,
        end: end,
      );
      state = state.copyWith(isLoadingReport: false, reportData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH HOUSEHOLD REPORT: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(
        isLoadingReport: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Analyze scrap image (AI)
  Future<AnalyzeScrapResultEntity?> analyzeScrap({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    state = state.copyWith(isAnalyzing: true, errorMessage: null);

    try {
      final result = await _analyzeScrap(
        imageBytes: imageBytes,
        fileName: fileName,
      );
      state = state.copyWith(
        isAnalyzing: false,
        analyzeResult: result,
      );
      return result;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR ANALYZE SCRAP: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(
        isAnalyzing: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Create Time Slot
  Future<ScrapPostTimeSlotEntity?> createTimeSlot({
    required String postId,
    required String specificDate,
    required String startTime,
    required String endTime,
    bool refreshDetail = true,
  }) async {
    state = state.copyWith(isUpdatingTimeSlot: true, errorMessage: null);
    try {
      final result = await _createTimeSlot(
        postId: postId,
        specificDate: specificDate,
        startTime: startTime,
        endTime: endTime,
      );

      // Auto refresh detail data after successful create
      if (refreshDetail) {
        await fetchDetail(postId);
      }

      state = state.copyWith(isUpdatingTimeSlot: false);
      return result;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR CREATE TIME SLOT: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isUpdatingTimeSlot: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Update Time Slot
  Future<ScrapPostTimeSlotEntity?> updateTimeSlot({
    required String postId,
    required String timeSlotId,
    required String specificDate,
    required String startTime,
    required String endTime,
    bool refreshDetail = true,
  }) async {
    state = state.copyWith(isUpdatingTimeSlot: true, errorMessage: null);
    try {
      final result = await _updateTimeSlot(
        postId: postId,
        timeSlotId: timeSlotId,
        specificDate: specificDate,
        startTime: startTime,
        endTime: endTime,
      );

      // Auto refresh detail data after successful update
      if (refreshDetail) {
        await fetchDetail(postId);
      }

      state = state.copyWith(isUpdatingTimeSlot: false);
      return result;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE TIME SLOT: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isUpdatingTimeSlot: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Delete Time Slot
  Future<bool> deleteTimeSlot({
    required String postId,
    required String timeSlotId,
    bool refreshDetail = true,
  }) async {
    state = state.copyWith(isUpdatingTimeSlot: true, errorMessage: null);
    try {
      final result = await _deleteTimeSlot(
        postId: postId,
        timeSlotId: timeSlotId,
      );

      // Auto refresh detail data after successful delete
      if (refreshDetail && result) {
        await fetchDetail(postId);
      }

      state = state.copyWith(isUpdatingTimeSlot: false);
      return result;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR DELETE TIME SLOT: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isUpdatingTimeSlot: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Reset State
  void reset() {
    state = ScrapPostState();
  }
}
