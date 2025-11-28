import 'package:GreenConnectMobile/features/schedule/data/datasources/schedule_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/schedule/data/repository/schedule_repository_impl.dart';
import 'package:GreenConnectMobile/features/schedule/domain/repository/schedule_repository.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/create_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/get_all_schedules_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/get_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/process_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/toggle_cancel_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/domain/usecases/update_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:GreenConnectMobile/features/schedule/presentation/viewmodels/states/schedule_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ==================
///  Remote DataSource
/// ==================
final scheduleRemoteDsProvider = Provider<ScheduleRemoteDataSourceImpl>((ref) {
  return ScheduleRemoteDataSourceImpl();
});

/// =============
///  Repository
/// =============
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final ds = ref.read(scheduleRemoteDsProvider);
  return ScheduleRepositoryImpl(ds);
});

/// =============
///  UseCases
/// =============

// Get all schedules
final getAllSchedulesUsecaseProvider = Provider<GetAllSchedulesUsecase>((ref) {
  return GetAllSchedulesUsecase(ref.read(scheduleRepositoryProvider));
});

// Get schedule detail
final getScheduleDetailUsecaseProvider =
    Provider<GetScheduleDetailUsecase>((ref) {
  return GetScheduleDetailUsecase(ref.read(scheduleRepositoryProvider));
});

// Update schedule
final updateScheduleUsecaseProvider = Provider<UpdateScheduleUsecase>((ref) {
  return UpdateScheduleUsecase(ref.read(scheduleRepositoryProvider));
});

// Create schedule
final createScheduleUsecaseProvider = Provider<CreateScheduleUsecase>((ref) {
  return CreateScheduleUsecase(ref.read(scheduleRepositoryProvider));
});

// Toggle cancel schedule
final toggleCancelScheduleUsecaseProvider =
    Provider<ToggleCancelScheduleUsecase>((ref) {
  return ToggleCancelScheduleUsecase(ref.read(scheduleRepositoryProvider));
});

// Process schedule
final processScheduleUsecaseProvider = Provider<ProcessScheduleUsecase>((ref) {
  return ProcessScheduleUsecase(ref.read(scheduleRepositoryProvider));
});

/// =============
///  ViewModel
/// =============
final scheduleViewModelProvider =
    NotifierProvider<ScheduleViewModel, ScheduleState>(
  () => ScheduleViewModel(),
);
