import 'package:GreenConnectMobile/features/schedule/domain/entities/create_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_list_response.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_proposal_entity.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/update_schedule_request.dart';

abstract class ScheduleRepository {
  Future<ScheduleListResponse> getAllSchedules({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  });

  Future<ScheduleProposalEntity> getScheduleDetail(String scheduleId);

  Future<ScheduleProposalEntity> updateSchedule({
    required String scheduleId,
    required UpdateScheduleRequest request,
  });

  Future<ScheduleProposalEntity> createSchedule({
    required String offerId,
    required CreateScheduleRequest request,
  });

  Future<bool> toggleCancelSchedule(String scheduleId);

  Future<bool> processSchedule({
    required String scheduleId,
    required bool isAccepted,
  });
}
