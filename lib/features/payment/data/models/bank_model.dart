import 'package:GreenConnectMobile/features/payment/domain/entities/bank_entity.dart';

class BankModel {
  final int id;
  final String name;
  final String code;
  final String bin;
  final String shortName;
  final String logo;

  BankModel({
    required this.id,
    required this.name,
    required this.code,
    required this.bin,
    required this.shortName,
    required this.logo,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      bin: json['bin'] as String,
      shortName: json['shortName'] as String,
      logo: json['logo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'bin': bin,
      'shortName': shortName,
      'logo': logo,
    };
  }

  BankEntity toEntity() {
    return BankEntity(
      id: id,
      name: name,
      code: code,
      bin: bin,
      shortName: shortName,
      logo: logo,
    );
  }
}
