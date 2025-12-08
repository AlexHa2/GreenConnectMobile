import 'package:GreenConnectMobile/features/package/domain/entities/package_entity.dart';

class PackageModel extends PackageEntity {
  PackageModel({
    required super.packageId,
    required super.name,
    required super.description,
    required super.price,
    required super.packageType,
    super.connectionAmount,
    super.isActive,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      packageId: json['packageId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      packageType: json['packageType'] ?? 'Freemium',
      connectionAmount: json['connectionAmount'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'name': name,
      'description': description,
      'price': price,
      'packageType': packageType,
      'connectionAmount': connectionAmount,
      'isActive': isActive,
    };
  }

  PackageEntity toEntity() {
    return PackageEntity(
      packageId: packageId,
      name: name,
      description: description,
      price: price,
      packageType: packageType,
      connectionAmount: connectionAmount,
      isActive: isActive,
    );
  }
}
