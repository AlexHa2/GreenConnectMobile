import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_proposal_entity.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/update_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/repository/schedule_repository.dart';

class UpdateScheduleUsecase {
  final ScheduleRepository _repository;

  UpdateScheduleUsecase(this._repository);

  Future<ScheduleProposalEntity> call({
    required String scheduleId,
    required UpdateScheduleRequest request,
  }) async {
    return await _repository.updateSchedule(
      scheduleId: scheduleId,
      request: request,
    );
  }
}
