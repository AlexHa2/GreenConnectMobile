import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends UserModel {
  final String profileId;
  final String dateOfBirth;
  final String address;
  final String gender;

  ProfileModel({
    required this.profileId,
    required super.userId,
    required super.fullName,
    required super.phoneNumber,
    required super.pointBalance,
    required super.rank,
    required super.roles,
    super.avatarUrl,
    required this.dateOfBirth,
    required this.address,
    required this.gender,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profileId: json['profileId'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      pointBalance: json['pointBalance'] ?? 0,
      rank: json['rank'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      avatarUrl: json['avatarUrl'],
      dateOfBirth: json['dateOfBirth'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'pointBalance': pointBalance,
      'rank': rank,
      'roles': roles,
      'avatarUrl': avatarUrl,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'gender': gender,
    };
  }

  @override
  ProfileEntity toEntity() {
    return ProfileEntity(
      profileId: profileId,
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      pointBalance: pointBalance,
      rank: rank,
      roles: roles,
      avatarUrl: avatarUrl,
      dateOfBirth: dateOfBirth,
      address: address,
      gender: gender,
    );
  }
}
