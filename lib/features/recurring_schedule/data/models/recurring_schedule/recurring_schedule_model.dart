import 'package:GreenConnectMobile/features/post/data/models/scrap_post/location_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/schedule_detail_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/domain/entities/recurring_schedule_entity.dart';

class RecurringScheduleModel {
  final String id;
  final String title;
  final String description;
  final String address;
  final LocationModel? location;
  final bool mustTakeAll;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;
  final DateTime? lastRunDate;
  final DateTime? createdAt;
  final List<ScheduleDetailModel> scheduleDetails;

  RecurringScheduleModel({
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

  factory RecurringScheduleModel.fromJson(Map<String, dynamic> json) {
    final detailsJson = json['scheduleDetails'] as List<dynamic>? ?? [];
    return RecurringScheduleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      mustTakeAll: json['mustTakeAll'] ?? false,
      dayOfWeek: json['dayOfWeek'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isActive: json['isActive'] ?? false,
      lastRunDate: json['lastRunDate'] != null
          ? DateTime.tryParse(json['lastRunDate'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      scheduleDetails: detailsJson
          .map((e) => ScheduleDetailModel.fromJson(e))
          .toList(),
    );
  }

  RecurringScheduleEntity toEntity() {
    return RecurringScheduleEntity(
      id: id,
      title: title,
      description: description,
      address: address,
      location: location?.toEntity(),
      mustTakeAll: mustTakeAll,
      dayOfWeek: dayOfWeek,
      startTime: startTime,
      endTime: endTime,
      isActive: isActive,
      lastRunDate: lastRunDate,
      createdAt: createdAt,
      scheduleDetails:
          scheduleDetails.map((e) => e.toEntity()).toList(),
    );
  }
}

