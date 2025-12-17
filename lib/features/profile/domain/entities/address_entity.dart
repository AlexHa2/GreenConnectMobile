class Address {
  final String street;
  final String wardCommune;
  final String stateProvince;
  final String country;
  final String zipCode;
  final double latitude;
  final double longitude;

  Address({
    required this.street,
    required this.wardCommune,
    required this.zipCode,
    required this.stateProvince,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}
