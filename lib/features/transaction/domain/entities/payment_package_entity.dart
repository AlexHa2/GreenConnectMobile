class PaymentPackageEntity {
  final String packageId;
  final String name;
  final String description;
  final int price;
  final int connectionAmount;
  final bool isActive;
  final String packageType;

  PaymentPackageEntity({
    required this.packageId,
    required this.name,
    required this.description,
    required this.price,
    required this.connectionAmount,
    required this.isActive,
    required this.packageType,
  });
}
