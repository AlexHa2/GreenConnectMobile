import 'package:GreenConnectMobile/core/di/auth_injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/datasources/abstract_datasources/recurring_schedule_remote_datasource.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/create_recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/paginated_recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/recurring_schedule_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/schedule_detail_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/update_recurring_schedule_model.dart';

class RecurringScheduleRemoteDataSourceImpl
    implements RecurringScheduleRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String _baseUrl = '/v1/recurring-schedules';

  @override
  Future<PaginatedRecurringScheduleModel> getSchedules({
    required int pageNumber,
    required int pageSize,
    bool? sortByCreatedAt,
  }) async {
    final res = await _apiClient.get(
      _baseUrl,
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (sortByCreatedAt != null) 'sortByCreatedAt': sortByCreatedAt,
      },
    );
    return PaginatedRecurringScheduleModel.fromJson(res.data);
  }

  @override
  Future<RecurringScheduleModel> getSchedule(String id) async {
    final res = await _apiClient.get('$_baseUrl/$id');
    return RecurringScheduleModel.fromJson(res.data);
  }

  @override
  Future<RecurringScheduleModel> createSchedule(
    CreateRecurringScheduleModel model,
  ) async {
    final res = await _apiClient.post(_baseUrl, data: model.toJson());
    return RecurringScheduleModel.fromJson(res.data);
  }

  @override
  Future<bool> updateSchedule({
    required String id,
    required UpdateRecurringScheduleModel model,
  }) async {
    final res = await _apiClient.patch('$_baseUrl/$id', data: model.toJson());
    return res.statusCode == 200;
  }

  @override
  Future<bool> toggleSchedule(String id) async {
    final res = await _apiClient.patch('$_baseUrl/$id/toggle');
    return res.statusCode == 204 || res.statusCode == 200;
  }

  @override
  Future<ScheduleDetailModel> createScheduleDetail({
    required String scheduleId,
    required ScheduleDetailModel model,
  }) async {
    final res = await _apiClient.post(
      '$_baseUrl/$scheduleId/details',
      data: {
        'scrapCategoryId': model.scrapCategoryId,
        'quantity': model.quantity ?? 0,
        'unit': model.unit,
        'amountDescription': model.amountDescription,
        'type': model.type ?? 'Sale',
      },
    );
    return ScheduleDetailModel.fromJson(res.data);
  }

  @override
  Future<ScheduleDetailModel> updateScheduleDetail({
    required String scheduleId,
    required String detailId,
    num? quantity,
    String? unit,
    String? amountDescription,
    String? type,
  }) async {
    final res = await _apiClient.patch(
      '$_baseUrl/$scheduleId/details/$detailId',
      queryParameters: {
        if (quantity != null) 'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (amountDescription != null) 'amountDescription': amountDescription,
        if (type != null) 'type': type,
      },
    );
    return ScheduleDetailModel.fromJson(res.data);
  }

  @override
  Future<ScheduleDetailModel> getScheduleDetail(String detailId) async {
    final res = await _apiClient.get('$_baseUrl/details/$detailId');
    return ScheduleDetailModel.fromJson(res.data);
  }

  @override
  Future<bool> deleteScheduleDetail({
    required String scheduleId,
    required String detailId,
  }) async {
    final res = await _apiClient.delete(
      '$_baseUrl/$scheduleId/details/$detailId',
    );
    return res.statusCode == 204 || res.statusCode == 200;
  }
}

