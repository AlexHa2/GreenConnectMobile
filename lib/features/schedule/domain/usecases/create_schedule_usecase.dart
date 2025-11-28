import 'package:GreenConnectMobile/features/schedule/domain/entities/create_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_proposal_entity.dart';
import 'package:GreenConnectMobile/features/schedule/domain/repository/schedule_repository.dart';

class CreateScheduleUsecase {
  final ScheduleRepository _repository;

  CreateScheduleUsecase(this._repository);

  Future<ScheduleProposalEntity> call({
    required String offerId,
    required CreateScheduleRequest request,
  }) async {
    return await _repository.createSchedule(
      offerId: offerId,
      request: request,
    );
  }
}
