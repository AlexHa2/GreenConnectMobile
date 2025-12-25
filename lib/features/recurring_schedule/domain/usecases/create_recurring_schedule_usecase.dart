import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class CreateRecurringScheduleUsecase {
  final RecurringScheduleRepository repository;
  CreateRecurringScheduleUsecase(this.repository);

  Future<RecurringScheduleEntity> call(RecurringScheduleEntity entity) {
    return repository.createSchedule(entity);
  }
}

