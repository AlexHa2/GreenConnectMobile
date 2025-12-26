import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/create_recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/paginated_recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/schedule_detail_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/update_recurring_schedule_model.dart';

abstract class RecurringScheduleRemoteDataSource {
  Future<PaginatedRecurringScheduleModel> getSchedules({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatedAt,
  });

  Future<RecurringScheduleModel> getSchedule(String id);

  Future<RecurringScheduleModel> createSchedule(
    CreateRecurringScheduleModel model,
  );

  Future<bool> updateSchedule({
    required String id,
    required UpdateRecurringScheduleModel model,
  });

  Future<bool> toggleSchedule(String id);

  Future<ScheduleDetailModel> createScheduleDetail({
    required String scheduleId,
    required ScheduleDetailModel model,
  });

  Future<ScheduleDetailModel> updateScheduleDetail({
    required String scheduleId,
    required String detailId,
    num? quantity,
    String? unit,
    String? amountDescription,
    String? type,
  });

  Future<ScheduleDetailModel> getScheduleDetail(String detailId);

  Future<bool> deleteScheduleDetail({
    required String scheduleId,
    required String detailId,
  });
}

