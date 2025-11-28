import 'package:GreenConnectMobile/features/schedule/domain/repository/schedule_repository.dart';

class ProcessScheduleUsecase {
  final ScheduleRepository _repository;

  ProcessScheduleUsecase(this._repository);

  Future<bool> call({
    required String scheduleId,
    required bool isAccepted,
  }) async {
    return await _repository.processSchedule(
      scheduleId: scheduleId,
      isAccepted: isAccepted,
    );
  }
}
