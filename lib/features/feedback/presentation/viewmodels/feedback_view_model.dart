import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/create_feedback_request.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/update_feedback_request.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/create_feedback_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/delete_feedback_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/get_feedback_detail_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/get_my_feedbacks_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/domain/usecases/update_feedback_usecase.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/providers/feedback_providers.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/viewmodels/states/feedback_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackViewModel extends Notifier<FeedbackState> {
  late GetMyFeedbacksUsecase _getMyFeedbacks;
  late GetFeedbackDetailUsecase _getFeedbackDetail;
  late CreateFeedbackUsecase _createFeedback;
  late UpdateFeedbackUsecase _updateFeedback;
  late DeleteFeedbackUsecase _deleteFeedback;

  @override
  FeedbackState build() {
    _getMyFeedbacks = ref.read(getMyFeedbacksUsecaseProvider);
    _getFeedbackDetail = ref.read(getFeedbackDetailUsecaseProvider);
    _createFeedback = ref.read(createFeedbackUsecaseProvider);
    _updateFeedback = ref.read(updateFeedbackUsecaseProvider);
    _deleteFeedback = ref.read(deleteFeedbackUsecaseProvider);
    return FeedbackState();
  }

  /// Fetch my feedbacks with pagination
  Future<void> fetchMyFeedbacks({
    required int page,
    required int size,
    bool? sortByCreatAt,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _getMyFeedbacks(
        pageNumber: page,
        pageSize: size,
        sortByCreatAt: sortByCreatAt,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH MY FEEDBACKS: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }

  /// Fetch feedback detail
  Future<void> fetchFeedbackDetail(String feedbackId) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);

    try {
      final result = await _getFeedbackDetail(feedbackId);
      state = state.copyWith(isLoadingDetail: false, detailData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH FEEDBACK DETAIL: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state =
          state.copyWith(isLoadingDetail: false, errorMessage: e.toString());
    }
  }

  /// Create new feedback
  Future<bool> createFeedback({
    required String transactionId,
    required int rate,
    required String comment,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final request = CreateFeedbackRequest(
        transactionId: transactionId,
        rate: rate,
        comment: comment,
      );
      final result = await _createFeedback(request);
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR CREATE FEEDBACK: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Update feedback
  Future<bool> updateFeedback({
    required String feedbackId,
    int? rate,
    String? comment,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final request = UpdateFeedbackRequest(
        rate: rate,
        comment: comment,
      );
      final result = await _updateFeedback(
        feedbackId: feedbackId,
        request: request,
      );
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE FEEDBACK: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Delete feedback
  Future<bool> deleteFeedback(String feedbackId) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final success = await _deleteFeedback(feedbackId);
      state = state.copyWith(isProcessing: false);
      return success;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR DELETE FEEDBACK: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }
}
