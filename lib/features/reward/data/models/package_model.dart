import 'package:GreenConnectMobile/features/reward/domain/entities/package_entity.dart';

class PackageModel extends PackageEntity {
  PackageModel({
    required super.packageId,
    required super.name,
    required super.description,
    required super.price,
    super.connectionAmount,
    super.isActive,
    required super.packageType,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      packageId: json['packageId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      connectionAmount: json['connectionAmount'],
      isActive: json['isActive'],
      packageType: json['packageType'] ?? 'Freemium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'name': name,
      'description': description,
      'price': price,
      'connectionAmount': connectionAmount,
      'isActive': isActive,
      'packageType': packageType,
    };
  }

  PackageEntity toEntity() {
    return PackageEntity(
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
