// lib/data/models/user_model.dart
import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.fullName,
    required super.phoneNumber,
    required super.pointBalance,
    required super.rank,
    required super.roles,
    super.avatarUrl,
  });

  @override
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      pointBalance: json['pointBalance'] ?? 0,
      rank: json['rank'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'pointBalance': pointBalance,
      'rank': rank,
      'roles': roles,
      'avatarUrl': avatarUrl,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      pointBalance: pointBalance,
      rank: rank,
      roles: roles,
      avatarUrl: avatarUrl,
    );
  }
}
