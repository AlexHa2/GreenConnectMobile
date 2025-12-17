import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/schedule/data/datasources/schedule_remote_datasource.dart';
import 'package:GreenConnectMobile/features/schedule/data/models/schedule_list_response_model.dart';
import 'package:GreenConnectMobile/features/schedule/data/models/schedule_proposal_model.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/create_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/update_schedule_request.dart';

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String _schedulesBaseUrl = '/v1/schedules';

  @override
  Future<ScheduleListResponseModel> getAllSchedules({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  }) async {
    final res = await _apiClient.get(
      _schedulesBaseUrl,
      queryParameters: {
        if (status != null) 'status': status,
        if (sortByCreateAtDesc != null)
          'sortByCreateAtDesc': sortByCreateAtDesc,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return ScheduleListResponseModel.fromJson(res.data);
  }

  @override
  Future<ScheduleProposalModel> getScheduleDetail(String scheduleId) async {
    final res = await _apiClient.get('$_schedulesBaseUrl/$scheduleId');
    return ScheduleProposalModel.fromJson(res.data);
  }

  @override
  Future<ScheduleProposalModel> updateSchedule({
    required String scheduleId,
    required UpdateScheduleRequest request,
  }) async {
    final queryParams = request.toQueryParams();
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    final res = await _apiClient.patch(
      '$_schedulesBaseUrl/$scheduleId?$queryString',
    );
    return ScheduleProposalModel.fromJson(res.data);
  }

  @override
  Future<ScheduleProposalModel> createSchedule({
    required String offerId,
    required CreateScheduleRequest request,
  }) async {
    final res = await _apiClient.post(
      '$_schedulesBaseUrl/$offerId',
      data: request.toJson(),
    );
    return ScheduleProposalModel.fromJson(res.data);
  }

  @override
  Future<bool> toggleCancelSchedule(String scheduleId) async {
    final res = await _apiClient.post(
      '$_schedulesBaseUrl/$scheduleId/toggle-cancel',
    );
    return res.statusCode == 200;
  }

  @override
  Future<bool> processSchedule({
    required String scheduleId,
    required bool isAccepted,
    String? responseMessage,
  }) async {
    final queryParams = <String, String>{
      'isAccepted': isAccepted.toString(),
      if (responseMessage != null) 'responseMessage': Uri.encodeComponent(responseMessage),
    };
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    final res = await _apiClient.patch(
      '$_schedulesBaseUrl/$scheduleId/process?$queryString',
    );
    return res.statusCode == 200;
  }
}
