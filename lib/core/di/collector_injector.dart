import 'package:GreenConnectMobile/features/collector/data/datasources/collector_report_remote_datasource.dart';
import 'package:GreenConnectMobile/features/collector/data/datasources/collector_report_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/collector/data/repository/collector_report_repository_impl.dart';
import 'package:GreenConnectMobile/features/collector/domain/repository/collector_report_repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initCollectorModule() async {
  // DataSource
  sl.registerLazySingleton<CollectorReportRemoteDataSource>(
    () => CollectorReportRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<CollectorReportRepository>(
    () => CollectorReportRepositoryImpl(sl()),
  );
}

