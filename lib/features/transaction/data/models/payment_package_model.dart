import 'package:GreenConnectMobile/features/transaction/domain/entities/payment_package_entity.dart';

class PaymentPackageModel {
  final String packageId;
  final String name;
  final String description;
  final int price;
  final int connectionAmount;
  final bool isActive;
  final String packageType;

  PaymentPackageModel({
    required this.packageId,
    required this.name,
    required this.description,
    required this.price,
    required this.connectionAmount,
    required this.isActive,
    required this.packageType,
  });

  factory PaymentPackageModel.fromJson(Map<String, dynamic> json) {
    return PaymentPackageModel(
      packageId: json['packageId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      connectionAmount: json['connectionAmount'] ?? 0,
      isActive: json['isActive'] ?? false,
      packageType: json['packageType'] ?? '',
    );
  }

  PaymentPackageEntity toEntity() {
    return PaymentPackageEntity(
      packageId: packageId,
      name: name,
      description: description,
      price: price,
      connectionAmount: connectionAmount,
      isActive: isActive,
      packageType: packageType,
    );
  }
}
