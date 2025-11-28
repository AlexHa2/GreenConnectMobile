import 'package:GreenConnectMobile/features/schedule/data/datasources/schedule_remote_datasource.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/create_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_list_response.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_proposal_entity.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/update_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/repository/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource _remoteDataSource;

  ScheduleRepositoryImpl(this._remoteDataSource);

  @override
  Future<ScheduleListResponse> getAllSchedules({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  }) async {
    final model = await _remoteDataSource.getAllSchedules(
      status: status,
      sortByCreateAtDesc: sortByCreateAtDesc,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
    return model.toEntity();
  }

  @override
  Future<ScheduleProposalEntity> getScheduleDetail(String scheduleId) async {
    final model = await _remoteDataSource.getScheduleDetail(scheduleId);
    return model.toEntity();
  }

  @override
  Future<ScheduleProposalEntity> updateSchedule({
    required String scheduleId,
    required UpdateScheduleRequest request,
  }) async {
    final model = await _remoteDataSource.updateSchedule(
      scheduleId: scheduleId,
      request: request,
    );
    return model.toEntity();
  }

  @override
  Future<ScheduleProposalEntity> createSchedule({
    required String offerId,
    required CreateScheduleRequest request,
  }) async {
    final model = await _remoteDataSource.createSchedule(
      offerId: offerId,
      request: request,
    );
    return model.toEntity();
  }

  @override
  Future<bool> toggleCancelSchedule(String scheduleId) async {
    return await _remoteDataSource.toggleCancelSchedule(scheduleId);
  }

  @override
  Future<bool> processSchedule({
    required String scheduleId,
    required bool isAccepted,
  }) async {
    return await _remoteDataSource.processSchedule(
      scheduleId: scheduleId,
      isAccepted: isAccepted,
    );
  }
}
