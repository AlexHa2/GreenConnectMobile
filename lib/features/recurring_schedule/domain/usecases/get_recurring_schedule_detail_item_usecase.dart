import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class GetRecurringScheduleDetailItemUsecase {
  final RecurringScheduleRepository repository;
  GetRecurringScheduleDetailItemUsecase(this.repository);

  Future<RecurringScheduleDetailEntity> call(String id) {
    return repository.getScheduleDetailItem(id);
  }
}

