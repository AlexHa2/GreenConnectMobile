import 'package:GreenConnectMobile/features/recurring_schedule/data/datasources/recurring_schedule_remote_datasource.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/repository/recurring_schedule_repository_impl.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/create_recurring_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/create_recurring_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/delete_recurring_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/get_recurring_schedule_detail_item_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/get_recurring_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/get_recurring_schedules_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/toggle_recurring_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/update_recurring_schedule_detail_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/usecases/update_recurring_schedule_usecase.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/presentation/viewmodels/recurring_schedule_view_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/presentation/viewmodels/states/recurring_schedule_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DataSource
final recurringScheduleRemoteDsProvider =
    Provider<RecurringScheduleRemoteDataSourceImpl>((ref) {
  return RecurringScheduleRemoteDataSourceImpl();
});

/// Repository
final recurringScheduleRepositoryProvider =
    Provider<RecurringScheduleRepository>((ref) {
  final ds = ref.read(recurringScheduleRemoteDsProvider);
  return RecurringScheduleRepositoryImpl(ds);
});

/// Usecases
final getRecurringSchedulesUsecaseProvider =
    Provider<GetRecurringSchedulesUsecase>((ref) {
  return GetRecurringSchedulesUsecase(
    ref.read(recurringScheduleRepositoryProvider),
  );
});

final getRecurringScheduleDetailUsecaseProvider =
    Provider<GetRecurringScheduleDetailUsecase>((ref) {
  return GetRecurringScheduleDetailUsecase(
    ref.read(recurringScheduleRepositoryProvider),
  );
});

final createRecurringScheduleUsecaseProvider =
    Provider<CreateRecurringScheduleUsecase>((ref) {
  return CreateRecurringScheduleUsecase(
    ref.read(recurringScheduleRepositoryProvider),
  );
});

final updateRecurringScheduleUsecaseProvider =
    Provider<UpdateRecurringScheduleUsecase>((ref) {
  return UpdateRecurringScheduleUsecase(
    ref.read(recurringScheduleRepositoryProvider),
  );
});

final toggleRecurringScheduleUsecaseProvider =
    Provider<ToggleRecurringScheduleUsecase>((ref) {
  return ToggleRecurringScheduleUsecase(
    ref.read(recurringScheduleRepositoryProvider),
  );
});

final createRecurringScheduleDetailUsecaseProvider =
    Provider<CreateRecurringScheduleDetailUsecase>((ref) {
  return CreateRecurringScheduleDetailUsecase(
    ref.read(recurringScheduleRepositoryProvider),
  );
});

final updateRecurringScheduleDetailUsecaseProvider =
    Provider<UpdateRecurringScheduleDetailUsecase>((ref) {
  return UpdateRecurringScheduleDetailUsecase(
    ref.read(recurringScheduleRepositoryProvider),
  );
});

final deleteRecurringScheduleDetailUsecaseProvider =
    Provider<DeleteRecurringScheduleDetailUsecase>((ref) {
  return DeleteRecurringScheduleDetailUsecase(
    ref.read(recurringScheduleRepositoryProvider),
  );
});

final getRecurringScheduleDetailItemUsecaseProvider =
    Provider<GetRecurringScheduleDetailItemUsecase>((ref) {
  return GetRecurringScheduleDetailItemUsecase(
    ref.read(recurringScheduleRepositoryProvider),
  );
});

/// ViewModel
final recurringScheduleViewModelProvider =
    NotifierProvider<RecurringScheduleViewModel, RecurringScheduleState>(
  () => RecurringScheduleViewModel(),
);

