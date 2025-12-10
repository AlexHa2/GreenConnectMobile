import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/create_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/update_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/create_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/get_all_schedules_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/get_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/process_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/toggle_cancel_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/update_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/presentation/providers/schedule_providers.dart';
import 'package:GreenConnectMobile/features/schedule/presentation/viewmodels/states/schedule_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleViewModel extends Notifier<ScheduleState> {
  late GetAllSchedulesUsecase _getAllSchedules;
  late GetScheduleDetailUsecase _getScheduleDetail;
  late UpdateScheduleUsecase _updateSchedule;
  late CreateScheduleUsecase _createSchedule;
  late ToggleCancelScheduleUsecase _toggleCancel;
  late ProcessScheduleUsecase _processSchedule;

  @override
  ScheduleState build() {
    _getAllSchedules = ref.read(getAllSchedulesUsecaseProvider);
    _getScheduleDetail = ref.read(getScheduleDetailUsecaseProvider);
    _updateSchedule = ref.read(updateScheduleUsecaseProvider);
    _createSchedule = ref.read(createScheduleUsecaseProvider);
    _toggleCancel = ref.read(toggleCancelScheduleUsecaseProvider);
    _processSchedule = ref.read(processScheduleUsecaseProvider);
    return ScheduleState();
  }

  /// Fetch all schedules with filters
  Future<void> fetchAllSchedules({
    String? status,
    bool? sortByCreateAtDesc,
    required int page,
    required int size,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);

    try {
      final result = await _getAllSchedules(
        status: status,
        sortByCreateAtDesc: sortByCreateAtDesc,
        pageNumber: page,
        pageSize: size,
      );
      state = state.copyWith(isLoadingList: false, listData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH SCHEDULES: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoadingList: false, errorMessage: e.toString());
    }
  }

  /// Fetch schedule detail
  Future<void> fetchScheduleDetail(String scheduleId) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);

    try {
      final result = await _getScheduleDetail(scheduleId);
      state = state.copyWith(isLoadingDetail: false, detailData: result);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH SCHEDULE DETAIL: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Update schedule (reschedule)
  Future<bool> updateSchedule({
    required String scheduleId,
    required UpdateScheduleRequest request,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final result = await _updateSchedule(
        scheduleId: scheduleId,
        request: request,
      );
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPDATE SCHEDULE: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Create new schedule for offer
  Future<bool> createSchedule({
    required String offerId,
    required CreateScheduleRequest request,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final result = await _createSchedule(
        offerId: offerId,
        request: request,
      );
      state = state.copyWith(isProcessing: false, detailData: result);
      return true;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR CREATE SCHEDULE: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Toggle cancel schedule
  Future<bool> toggleCancelSchedule(String scheduleId) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final success = await _toggleCancel(scheduleId);
      state = state.copyWith(isProcessing: false);
      return success;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR TOGGLE CANCEL SCHEDULE: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Process schedule (accept/reject)
  Future<bool> processSchedule({
    required String scheduleId,
    required bool isAccepted,
    String? responseMessage,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final success = await _processSchedule(
        scheduleId: scheduleId,
        isAccepted: isAccepted,
        responseMessage: responseMessage,
      );
      state = state.copyWith(isProcessing: false);
      return success;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR PROCESS SCHEDULE: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }
}
