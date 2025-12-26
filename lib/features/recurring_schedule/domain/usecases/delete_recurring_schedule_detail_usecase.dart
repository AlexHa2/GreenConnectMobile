import 'package:GreenConnectMobile/features/recurring_schedule/domain/repository/recurring_schedule_repository.dart';

class DeleteRecurringScheduleDetailUsecase {
  final RecurringScheduleRepository repository;
  DeleteRecurringScheduleDetailUsecase(this.repository);

  Future<bool> call({
    required String scheduleId,
    required String detailId,
  }) {
    return repository.deleteScheduleDetail(
      scheduleId: scheduleId,
      detailId: detailId,
    );
  }
}

