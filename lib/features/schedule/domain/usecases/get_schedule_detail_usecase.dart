import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_proposal_entity.dart';
import 'package:GreenConnectMobile/features/schedule/domain/repository/schedule_repository.dart';

class GetScheduleDetailUsecase {
  final ScheduleRepository _repository;

  GetScheduleDetailUsecase(this._repository);

  Future<ScheduleProposalEntity> call(String scheduleId) async {
    return await _repository.getScheduleDetail(scheduleId);
  }
}
