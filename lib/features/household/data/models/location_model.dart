import 'package:GreenConnectMobile/features/household/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel({required super.longitude, required super.latitude});
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'longitude': longitude,
    'latitude': latitude,
  };

  LocationEntity toEntity() {
    return LocationEntity(longitude: longitude, latitude: latitude);
  }
}
