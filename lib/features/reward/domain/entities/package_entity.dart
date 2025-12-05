class PackageEntity {
  final String packageId;
  final String name;
  final String description;
  final int price;
  final int? connectionAmount;
  final bool? isActive;
  final String packageType; // "Freemium" or "Paid"

  PackageEntity({
    required this.packageId,
    required this.name,
    required this.description,
    required this.price,
    this.connectionAmount,
    this.isActive,
    required this.packageType,
  });
}
