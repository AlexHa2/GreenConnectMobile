// scrap_post_entity.dart
import 'package:GreenConnectMobile/features/household/domain/entities/household_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_detail_entity.dart';

class ScrapPostEntity {
  final String? scrapPostId;
  final String title;
  final String description;
  final String address;
  final String availableTimeRange;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;
  final bool mustTakeAll;
  final LocationEntity location;
  final HouseholdEntity? household;
  final List<ScrapPostDetailEntity> scrapPostDetails;

  ScrapPostEntity({
    this.scrapPostId,
    required this.title,
    required this.description,
    required this.address,
    required this.availableTimeRange,
    this.createdAt,
    this.updatedAt,
    this.status,
    required this.mustTakeAll,
    required this.location,
    this.household,
    required this.scrapPostDetails,
  });
}
