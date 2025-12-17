import 'package:GreenConnectMobile/features/collector/data/datasources/collector_report_remote_datasource.dart';
import 'package:GreenConnectMobile/features/collector/domain/entities/collector_report_entity.dart';
import 'package:GreenConnectMobile/features/collector/domain/repository/collector_report_repository.dart';

class CollectorReportRepositoryImpl implements CollectorReportRepository {
  final CollectorReportRemoteDataSource _remoteDataSource;

  CollectorReportRepositoryImpl(this._remoteDataSource);

  @override
  Future<CollectorReportEntity> getCollectorReport({
    required DateTime start,
    required DateTime end,
  }) async {
    final result = await _remoteDataSource.getCollectorReport(
      start: start,
      end: end,
    );
    return result.toEntity();
  }
}

