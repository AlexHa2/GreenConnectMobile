import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class ToggleRecurringScheduleUsecase {
  final RecurringScheduleRepository repository;
  ToggleRecurringScheduleUsecase(this.repository);

  Future<bool> call(String id) {
    return repository.toggleSchedule(id);
  }
}

