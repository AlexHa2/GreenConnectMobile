import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';

class UserUpdateModel extends UserUpdateEntity {
  UserUpdateModel({
    required super.fullName,
    required super.address,
    required super.gender,
    required super.dateOfBirth,
  });

  @override
  factory UserUpdateModel.fromJson(Map<String, dynamic> json) {
    return UserUpdateModel(
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'address': address,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
    };
  }

}
