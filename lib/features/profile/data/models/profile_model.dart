import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends UserModel {
  ProfileModel({
    required super.profileId,
    required super.userId,
    required super.fullName,
    required super.phoneNumber,
    super.dateOfBirth,
    super.address,
    super.gender,
    required super.pointBalance,
    super.creditBalance,
    required super.rank,
    required super.roles,
    super.avatarUrl,
    super.buyerType,
    super.bankCode,
    super.bankAccountNumber,
    super.bankAccountName,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profileId: json['profileId'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      address: json['address'],
      gender: json['gender'],
      pointBalance: json['pointBalance'] ?? 0,
      creditBalance: json['creditBalance'],
      rank: json['rank'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      avatarUrl: json['avatarUrl'],
      buyerType: json['buyerType'],
      bankCode: json['bankCode'],
      bankAccountNumber: json['bankAccountNumber'],
      bankAccountName: json['bankAccountName'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'gender': gender,
      'pointBalance': pointBalance,
      'creditBalance': creditBalance,
      'rank': rank,
      'roles': roles,
      'avatarUrl': avatarUrl,
      'buyerType': buyerType,
      'bankCode': bankCode,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountName': bankAccountName,
    };
  }

  @override
  ProfileEntity toEntity() {
    return ProfileEntity(
      profileId: profileId!,
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      address: address,
      gender: gender,
      pointBalance: pointBalance,
      creditBalance: creditBalance,
      rank: rank,
      roles: roles,
      avatarUrl: avatarUrl,
      buyerType: buyerType,
      bankCode: bankCode,
      bankAccountNumber: bankAccountNumber,
      bankAccountName: bankAccountName,
    );
  }
}
