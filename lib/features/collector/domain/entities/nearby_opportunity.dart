class NearbyOpportunity {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final double distance; // in kilometers
  final double estimatedValue;
  final String category;
  final DateTime createdAt;

  const NearbyOpportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.estimatedValue,
    required this.category,
    required this.createdAt,
  });

  factory NearbyOpportunity.empty() {
    return NearbyOpportunity(
      id: '',
      title: '',
      description: '',
      latitude: 0.0,
      longitude: 0.0,
      distance: 0.0,
      estimatedValue: 0.0,
      category: '',
      createdAt: DateTime.now(),
    );
  }
}
