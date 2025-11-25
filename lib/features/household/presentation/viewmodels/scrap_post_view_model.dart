import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_detail_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/update_scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/create_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/delete_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/get_my_scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/get_scrap_post_detail_usecases.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/scrap_post_usecases.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/toggle_scrap_post_usecase.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/update_scrap_detail_usecase.dart';
import 'package:GreenConnectMobile/features/household/domain/usecases/update_scrap_usecase.dart';
import 'package:GreenConnectMobile/features/household/presentation/providers/scrap_post_providers.dart';
import 'package:GreenConnectMobile/features/household/presentation/viewmodels/states/scrap_post_state.dart';
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
  Future<bool> updatePost({required UpdateScrapPostEntity post}) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);
    try {
      await _updatePost(post);

      state = state.copyWith(isLoadingDetail: false);
      return true;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE POST SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isLoadingDetail: false,
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
  }) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);
    try {
      await _createDetail(postId: postId, detail: detail);

      state = state.copyWith(isLoadingDetail: false);
      return true;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR CREATE DETAIL SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Update Detail
  Future<bool> updateDetail({
    required String postId,
    required ScrapPostDetailEntity detail,
  }) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);
    try {
      await _updateDetail(postId: postId, detail: detail);

      state = state.copyWith(isLoadingDetail: false);
      return true;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE DETAIL SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Delete Detail
  Future<bool> deleteDetail({
    required String postId,
    required int categoryId,
  }) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);
    try {
      await _deleteDetail(postId: postId, categoryId: categoryId);

      state = state.copyWith(isLoadingDetail: false);
      return true;
    } catch (e, stacktrace) {
      if (e is AppException) {
        debugPrint('❌ ERROR DELETE DETAIL SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stacktrace');
      state = state.copyWith(
        isLoadingDetail: false,
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
