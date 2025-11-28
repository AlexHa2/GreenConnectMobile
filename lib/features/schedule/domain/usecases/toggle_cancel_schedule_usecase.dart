import 'package:GreenConnectMobile/features/schedule/domain/repository/schedule_repository.dart';

class ToggleCancelScheduleUsecase {
  final ScheduleRepository _repository;

  ToggleCancelScheduleUsecase(this._repository);

  Future<bool> call(String scheduleId) async {
    return await _repository.toggleCancelSchedule(scheduleId);
  }
}
