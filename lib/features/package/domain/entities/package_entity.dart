class PackageEntity {
  final String packageId;
  final String name;
  final String description;
  final double price;
  final String packageType; // "Freemium" or "Paid"
  final int? connectionAmount;
  final bool? isActive;

  PackageEntity({
    required this.packageId,
    required this.name,
    required this.description,
    required this.price,
    required this.packageType,
    this.connectionAmount,
    this.isActive,
  });

  bool get isFreemium => packageType == 'Freemium';
  bool get isPaid => packageType == 'Paid';
}
