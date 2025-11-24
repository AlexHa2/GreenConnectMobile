// update_scrap_post_model.dart
import 'package:GreenConnectMobile/features/household/domain/entities/update_scrap_post_entity.dart';

class UpdateScrapPostModel {
  final String scrapPostId;
  final String title;
  final String description;
  final String address;
  final String availableTimeRange;
  final bool mustTakeAll;
  final LocationUpdateModel location;

  UpdateScrapPostModel({
    required this.scrapPostId,
    required this.title,
    required this.description,
    required this.address,
    required this.availableTimeRange,
    required this.mustTakeAll,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "address": address,
      "availableTimeRange": availableTimeRange,
      "mustTakeAll": mustTakeAll,
      "location": location.toJson(),
    };
  }

  /// convert Entity → Model
  factory UpdateScrapPostModel.fromEntity(UpdateScrapPostEntity entity) {
    return UpdateScrapPostModel(
      scrapPostId: entity.scrapPostId,
      title: entity.title,
      description: entity.description,
      address: entity.address,
      availableTimeRange: entity.availableTimeRange,
      mustTakeAll: entity.mustTakeAll,
      location: LocationUpdateModel(
        longitude: entity.location.longitude,
        latitude: entity.location.latitude,
      ),
    );
  }
}

class LocationUpdateModel {
  final double longitude;
  final double latitude;

  LocationUpdateModel({required this.longitude, required this.latitude});

  Map<String, dynamic> toJson() {
    return {"longitude": longitude, "latitude": latitude};
  }
}
