import 'package:GreenConnectMobile/features/collector/domain/entities/collector_report_entity.dart';

abstract class CollectorReportRepository {
  Future<CollectorReportEntity> getCollectorReport({
    required DateTime start,
    required DateTime end,
  });
}

