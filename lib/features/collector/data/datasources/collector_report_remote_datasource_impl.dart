import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/collector/data/datasources/collector_report_remote_datasource.dart';
import 'package:GreenConnectMobile/features/collector/data/models/collector_report_model.dart';

class CollectorReportRemoteDataSourceImpl
    implements CollectorReportRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  static const String _reportsBaseUrl = '/v1/reports/collector';

  @override
  Future<CollectorReportModel> getCollectorReport({
    required DateTime start,
    required DateTime end,
  }) async {
    final queryParams = <String, dynamic>{
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };

    final res = await _apiClient.get(
      _reportsBaseUrl,
      queryParameters: queryParams,
    );
    return CollectorReportModel.fromJson(res.data);
  }
}

