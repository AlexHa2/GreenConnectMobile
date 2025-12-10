import 'package:GreenConnectMobile/features/schedule/data/models/schedule_list_response_model.dart';
import 'package:GreenConnectMobile/features/schedule/data/models/schedule_proposal_model.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/create_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/update_schedule_request.dart';

abstract class ScheduleRemoteDataSource {
  /// GET /api/v1/schedules - Get all schedules with filters
  Future<ScheduleListResponseModel> getAllSchedules({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  });

  /// GET /api/v1/schedules/{id} - Get schedule detail
  Future<ScheduleProposalModel> getScheduleDetail(String scheduleId);

  /// PATCH /api/v1/schedules/{id} - Update schedule
  Future<ScheduleProposalModel> updateSchedule({
    required String scheduleId,
    required UpdateScheduleRequest request,
  });

  /// POST /api/v1/schedules/{offerId} - Create new schedule for offer
  Future<ScheduleProposalModel> createSchedule({
    required String offerId,
    required CreateScheduleRequest request,
  });

  /// POST /api/v1/schedules/{id}/toggle-cancel - Toggle cancel status
  Future<bool> toggleCancelSchedule(String scheduleId);

  /// PATCH /api/v1/schedules/{id}/process - Process schedule (accept/reject)
  Future<bool> processSchedule({
    required String scheduleId,
    required bool isAccepted,
    String? responseMessage,
  });
}
