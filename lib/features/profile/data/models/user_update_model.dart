import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';

class UserUpdateModel extends UserUpdateEntity {
  UserUpdateModel({
    required super.fullName,
    required super.address,
    required super.gender,
    required super.dateOfBirth,
    super.bankCode,
    super.bankAccountNumber,
    super.bankAccountName,
  });

  @override
  factory UserUpdateModel.fromJson(Map<String, dynamic> json) {
    return UserUpdateModel(
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      bankCode: json['bankCode'],
      bankAccountNumber: json['bankAccountNumber'],
      bankAccountName: json['bankAccountName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'fullName': fullName,
      'address': address,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
    };
    
    // Only include bank fields if they are not null
    if (bankCode != null) data['bankCode'] = bankCode;
    if (bankAccountNumber != null) data['bankAccountNumber'] = bankAccountNumber;
    if (bankAccountName != null) data['bankAccountName'] = bankAccountName;
    
    return data;
  }

}
