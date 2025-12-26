import 'package:GreenConnectMobile/core/common/paginate/paginate_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';

class PaginatedRecurringScheduleEntity
    extends PaginatedResponseEntity<RecurringScheduleEntity> {
  PaginatedRecurringScheduleEntity({
    required super.data,
    required super.pagination,
  });
}

