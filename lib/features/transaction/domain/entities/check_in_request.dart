class CheckInRequest {
  final double longitude;
  final double latitude;

  CheckInRequest({
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
      };
}
