import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/paginated_recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';

abstract class RecurringScheduleRepository {
  Future<PaginatedRecurringScheduleEntity> getSchedules({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatedAt,
  });

  Future<RecurringScheduleEntity> getScheduleDetail(String id);

  Future<bool> toggleSchedule(String id);

  Future<bool> updateSchedule({
    required String id,
    required RecurringScheduleEntity schedule,
  });

  Future<RecurringScheduleEntity> createSchedule(
    RecurringScheduleEntity schedule,
  );

  Future<RecurringScheduleDetailEntity> createScheduleDetail({
    required String scheduleId,
    required RecurringScheduleDetailEntity detail,
  });

  Future<RecurringScheduleDetailEntity> updateScheduleDetail({
    required String scheduleId,
    required String detailId,
    num? quantity,
    String? unit,
    String? amountDescription,
    String? type,
  });

  Future<RecurringScheduleDetailEntity> getScheduleDetailItem(String detailId);

  Future<bool> deleteScheduleDetail({
    required String scheduleId,
    required String detailId,
  });
}

