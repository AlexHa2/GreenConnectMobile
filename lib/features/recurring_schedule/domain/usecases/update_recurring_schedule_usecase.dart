import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class UpdateRecurringScheduleUsecase {
  final RecurringScheduleRepository repository;
  UpdateRecurringScheduleUsecase(this.repository);

  Future<bool> call({
    required String id,
    required RecurringScheduleEntity entity,
  }) {
    return repository.updateSchedule(id: id, schedule: entity);
  }
}

