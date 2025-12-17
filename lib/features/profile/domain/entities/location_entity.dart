class LocationEntity {
  final double longitude;
  final double latitude;

  LocationEntity({required this.longitude, required this.latitude});

  Map<String, dynamic> toJson() => {
    'longitude': longitude,
    'latitude': latitude,
  };
}
