import 'dart:async';

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
    .autoDispose<CollectorReportEntity, String>((ref, weekKey) async {
  // Keep the provider alive to prevent automatic retry on error
  final link = ref.keepAlive();
  
  // Dispose the keepAlive after 5 minutes of inactivity
  Timer? timer;
  ref.onDispose(() => timer?.cancel());
  ref.onCancel(() {
    timer = Timer(const Duration(minutes: 5), link.close);
  });
  ref.onResume(() {
    timer?.cancel();
  });
  
  final repository = ref.watch(collectorReportRepositoryProvider);
  
  // Parse the weekKey back to dates
  final parts = weekKey.split('_');
  final start = DateTime.parse(parts[0]);
  final end = DateTime.parse(parts[1]);
  
  try {
    return await repository.getCollectorReport(
      start: start,
      end: end,
    );
  } catch (e) {
    // Keep the error state, don't retry automatically
    rethrow;
  }
});

