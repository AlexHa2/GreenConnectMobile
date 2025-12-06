import 'package:GreenConnectMobile/features/collector/data/models/collector_report_model.dart';

abstract class CollectorReportRemoteDataSource {
  /// GET /api/v1/reports/collector
  Future<CollectorReportModel> getCollectorReport({
    required DateTime start,
    required DateTime end,
  });
}

