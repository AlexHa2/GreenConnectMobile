import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class GetRecurringScheduleDetailUsecase {
  final RecurringScheduleRepository repository;
  GetRecurringScheduleDetailUsecase(this.repository);

  Future<RecurringScheduleEntity> call(String id) {
    return repository.getScheduleDetail(id);
  }
}

