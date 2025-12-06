import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/features/collector/domain/entities/collector_report_entity.dart';
import 'package:GreenConnectMobile/features/collector/domain/repository/collector_report_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final collectorReportRepositoryProvider =
    Provider<CollectorReportRepository>((ref) {
  return sl<CollectorReportRepository>();
});

// Use a stable key for the provider to prevent unnecessary refetches
final collectorReportProvider = FutureProvider.family
    .autoDispose<CollectorReportEntity, String>((ref, weekKey) {
  final repository = ref.watch(collectorReportRepositoryProvider);
  
  // Parse the weekKey back to dates
  final parts = weekKey.split('_');
  final start = DateTime.parse(parts[0]);
  final end = DateTime.parse(parts[1]);
  
  return repository.getCollectorReport(
    start: start,
    end: end,
  );
});

