import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class CreateRecurringScheduleDetailUsecase {
  final RecurringScheduleRepository repository;
  CreateRecurringScheduleDetailUsecase(this.repository);

  Future<RecurringScheduleDetailEntity> call({
    required String scheduleId,
    required RecurringScheduleDetailEntity detail,
  }) {
    return repository.createScheduleDetail(
      scheduleId: scheduleId,
      detail: detail,
    );
  }
}

