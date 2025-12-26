import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/create_recurring_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/create_recurring_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/delete_recurring_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/get_recurring_schedule_detail_item_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/get_recurring_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/get_recurring_schedules_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/toggle_recurring_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/update_recurring_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/update_recurring_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/presentation/providers/recurring_schedule_providers.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/presentation/viewmodels/states/recurring_schedule_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurringScheduleViewModel extends Notifier<RecurringScheduleState> {
  late GetRecurringSchedulesUsecase _getList;
  late GetRecurringScheduleDetailUsecase _getDetail;
  late CreateRecurringScheduleUsecase _create;
  late UpdateRecurringScheduleUsecase _update;
  late ToggleRecurringScheduleUsecase _toggle;
  late CreateRecurringScheduleDetailUsecase _createDetail;
  late UpdateRecurringScheduleDetailUsecase _updateDetail;
  late DeleteRecurringScheduleDetailUsecase _deleteDetail;
  late GetRecurringScheduleDetailItemUsecase _getDetailItem;

  @override
  RecurringScheduleState build() {
    _getList = ref.read(getRecurringSchedulesUsecaseProvider);
    _getDetail = ref.read(getRecurringScheduleDetailUsecaseProvider);
    _create = ref.read(createRecurringScheduleUsecaseProvider);
    _update = ref.read(updateRecurringScheduleUsecaseProvider);
    _toggle = ref.read(toggleRecurringScheduleUsecaseProvider);
    _createDetail = ref.read(createRecurringScheduleDetailUsecaseProvider);
    _updateDetail = ref.read(updateRecurringScheduleDetailUsecaseProvider);
    _deleteDetail = ref.read(deleteRecurringScheduleDetailUsecaseProvider);
    _getDetailItem = ref.read(getRecurringScheduleDetailItemUsecaseProvider);
    return const RecurringScheduleState();
  }

  Future<void> fetchList({
    required int page,
    required int size,
    bool? sortByCreatedAt,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);
    try {
      final res = await _getList(
        pageNumber: page,
        pageSize: size,
        sortByCreatedAt: sortByCreatedAt,
      );
      state = state.copyWith(isLoadingList: false, listData: res);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ FETCH RECURRING LIST: ${e.message}');
      }
      debugPrint('📌 STACK: $stack');
      state = state.copyWith(
        isLoadingList: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchDetail(String id) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);
    try {
      final res = await _getDetail(id);
      state = state.copyWith(isLoadingDetail: false, detailData: res);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ FETCH RECURRING DETAIL: ${e.message}');
      }
      debugPrint('📌 STACK: $stack');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> createSchedule(RecurringScheduleEntity entity) async {
    state = state.copyWith(isLoadingMutation: true, errorMessage: null);
    try {
      final res = await _create(entity);
      state = state.copyWith(
        isLoadingMutation: false,
        detailData: res,
      );
      return true;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ CREATE RECURRING: ${e.message}');
      }
      debugPrint('📌 STACK: $stack');
      state = state.copyWith(
        isLoadingMutation: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateSchedule({
    required String id,
    required RecurringScheduleEntity entity,
  }) async {
    state = state.copyWith(isLoadingMutation: true, errorMessage: null);
    try {
      final ok = await _update(id: id, entity: entity);
      state = state.copyWith(isLoadingMutation: false);
      return ok;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ UPDATE RECURRING: ${e.message}');
      }
      debugPrint('📌 STACK: $stack');
      state = state.copyWith(
        isLoadingMutation: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> toggleSchedule(String id) async {
    state = state.copyWith(isLoadingMutation: true, errorMessage: null);
    try {
      final ok = await _toggle(id);
      state = state.copyWith(isLoadingMutation: false);
      return ok;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ TOGGLE RECURRING: ${e.message}');
      }
      debugPrint('📌 STACK: $stack');
      state = state.copyWith(
        isLoadingMutation: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<RecurringScheduleDetailEntity?> createScheduleDetail({
    required String scheduleId,
    required RecurringScheduleDetailEntity detail,
  }) async {
    state = state.copyWith(isLoadingMutation: true, errorMessage: null);
    try {
      final res = await _createDetail(
        scheduleId: scheduleId,
        detail: detail,
      );
      state = state.copyWith(isLoadingMutation: false, detailItem: res);
      return res;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ CREATE RECURRING DETAIL: ${e.message}');
      }
      debugPrint('📌 STACK: $stack');
      state = state.copyWith(
        isLoadingMutation: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<RecurringScheduleDetailEntity?> updateScheduleDetail({
    required String scheduleId,
    required String detailId,
    num? quantity,
    String? unit,
    String? amountDescription,
    String? type,
  }) async {
    state = state.copyWith(isLoadingMutation: true, errorMessage: null);
    try {
      final res = await _updateDetail(
        scheduleId: scheduleId,
        detailId: detailId,
        quantity: quantity,
        unit: unit,
        amountDescription: amountDescription,
        type: type,
      );
      state = state.copyWith(isLoadingMutation: false, detailItem: res);
      return res;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ UPDATE RECURRING DETAIL: ${e.message}');
      }
      debugPrint('📌 STACK: $stack');
      state = state.copyWith(
        isLoadingMutation: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<RecurringScheduleDetailEntity?> getScheduleDetailItem(
      String detailId,) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);
    try {
      final res = await _getDetailItem(detailId);
      state = state.copyWith(isLoadingDetail: false, detailItem: res);
      return res;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ GET RECURRING DETAIL ITEM: ${e.message}');
      }
      debugPrint('📌 STACK: $stack');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<bool> deleteScheduleDetail({
    required String scheduleId,
    required String detailId,
  }) async {
    state = state.copyWith(isLoadingMutation: true, errorMessage: null);
    try {
      final ok = await _deleteDetail(
        scheduleId: scheduleId,
        detailId: detailId,
      );
      state = state.copyWith(isLoadingMutation: false);
      return ok;
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ DELETE RECURRING DETAIL: ${e.message}');
      }
      debugPrint('📌 STACK: $stack');
      state = state.copyWith(
        isLoadingMutation: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const RecurringScheduleState();
  }
}

