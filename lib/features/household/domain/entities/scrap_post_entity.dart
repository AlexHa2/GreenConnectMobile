import 'package:GreenConnectMobile/features/household/domain/entities/household_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_detai_entity.dart';

class ScrapPostEntity {
  final String? scrapPostId;
  final String title;
  final String description;
  final String address;
  final String availableTimeRange;
  final String? status;
  final String updatedAt;
  final String? createdAt;
  final String? householdId;
  final HouseholdEntity? household;
  final LocationEntity location;
  final bool mustTakeAll;
  final List<ScrapPostDetailEntity> scrapPostDetails;

  ScrapPostEntity({
    this.scrapPostId,
    required this.title,
    required this.description,
    required this.address,
    required this.availableTimeRange,
    this.status,
    required this.updatedAt,
    this.createdAt,
    this.householdId,
    this.household,
    required this.location,
    required this.mustTakeAll,
    required this.scrapPostDetails,
  });
}
