// scrap_post_model.dart

import 'package:GreenConnectMobile/features/post/data/models/scrap_post/household_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_detail_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/time_slot_model.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';

class ScrapPostModel {
  final String scrapPostId;
  final String title;
  final String description;
  final String address;
  final String? availableTimeRange;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? householdId;
  final HouseholdModel? household;
  final bool mustTakeAll;
  final List<ScrapPostDetailModel> scrapPostDetails;
  final List<TimeSlotModel> timeSlots;

  ScrapPostModel({
    required this.scrapPostId,
    required this.title,
    required this.description,
    required this.address,
    this.availableTimeRange,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.householdId,
    this.household,
    required this.mustTakeAll,
    required this.scrapPostDetails,
    this.timeSlots = const [],
  });

  factory ScrapPostModel.fromJson(Map<String, dynamic> json) {
    final dynamic idRaw = json['scrapPostId'] ?? json['id'];
    final details = (json['scrapPostDetails'] as List?) ?? const [];
    final timeSlotsList = (json['timeSlots'] as List?) ?? const [];

    return ScrapPostModel(
      scrapPostId: idRaw?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      availableTimeRange: json['availableTimeRange'],
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      householdId: json['householdId'],
      household: json['household'] != null
          ? HouseholdModel.fromJson(json['household'])
          : null,
      mustTakeAll: json['mustTakeAll'] ?? false,
      scrapPostDetails:
          details.map((e) => ScrapPostDetailModel.fromJson(e)).toList(),
      timeSlots: timeSlotsList.map((e) => TimeSlotModel.fromJson(e)).toList(),
    );
  }

  ScrapPostEntity toEntity() {
    return ScrapPostEntity(
      scrapPostId: scrapPostId,
      title: title,
      description: description,
      address: address,
      availableTimeRange: availableTimeRange,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
      mustTakeAll: mustTakeAll,
      household: household?.toEntity(),
      location: null,
      scrapPostDetails: scrapPostDetails.map((e) => e.toEntity()).toList(),
      scrapPostTimeSlots: timeSlots.map((e) => e.toEntity()).toList(),
    );
  }
}
