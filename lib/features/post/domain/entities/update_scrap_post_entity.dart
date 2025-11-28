// update_scrap_post_entity.dart
import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';

class UpdateScrapPostEntity {
  final String scrapPostId;
  final String title;
  final String description;
  final String address;
  final String availableTimeRange;
  final bool mustTakeAll;
  final LocationEntity location;

  UpdateScrapPostEntity({
    required this.scrapPostId,
    required this.title,
    required this.description,
    required this.address,
    required this.availableTimeRange,
    required this.mustTakeAll,
    required this.location,
  });
}

