// location_model.dart

import 'package:GreenConnectMobile/features/post/domain/entities/location_entity.dart';

class LocationModel {
  final double longitude;
  final double latitude;

  LocationModel({required this.longitude, required this.latitude});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      longitude: json['longitude'].toDouble(),
      latitude: json['latitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"longitude": longitude, "latitude": latitude};
  }

  LocationEntity toEntity() {
    return LocationEntity(longitude: longitude, latitude: latitude);
  }

  static LocationModel fromEntity(LocationEntity entity) {
    return LocationModel(
      longitude: entity.longitude,
      latitude: entity.latitude,
    );
  }
}
