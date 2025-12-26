import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';

class RecurringScheduleEntity {
  final String id;
  final String title;
  final String description;
  final String address;
  final LocationEntity? location;
  final bool mustTakeAll;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;
  final DateTime? lastRunDate;
  final DateTime? createdAt;
  final List<RecurringScheduleDetailEntity> scheduleDetails;

  const RecurringScheduleEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    this.location,
    required this.mustTakeAll,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    this.lastRunDate,
    this.createdAt,
    this.scheduleDetails = const [],
  });
}

