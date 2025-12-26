// scrap_post_entity.dart
import 'package:GreenConnectMobile/features/post/domain/entities/household_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_detail_entity.dart';

class ScrapPostTimeSlotEntity {
  final String? id;
  final String specificDate;
  final String startTime;
  final String endTime;
  final bool? isBooked;
  final String? scrapPostId;

  ScrapPostTimeSlotEntity({
    this.id,
    required this.specificDate,
    required this.startTime,
    required this.endTime,
    this.isBooked,
    this.scrapPostId,
  });
}

class ScrapPostEntity {
  final String? scrapPostId;
  final String title;
  final String description;
  final String address;
  final String? availableTimeRange;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;
  final bool mustTakeAll;
  final LocationEntity? location;
  final HouseholdEntity? household;
  final List<ScrapPostDetailEntity> scrapPostDetails;
  final List<ScrapPostTimeSlotEntity> scrapPostTimeSlots;

  ScrapPostEntity({
    this.scrapPostId,
    required this.title,
    required this.description,
    required this.address,
    this.availableTimeRange,
    this.createdAt,
    this.updatedAt,
    this.status,
    required this.mustTakeAll,
    this.location,
    this.household,
    required this.scrapPostDetails,
    this.scrapPostTimeSlots = const [],
  });
}
