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
    super.buyerType,
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
      buyerType: json['buyerType'],
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
      'buyerType': buyerType,
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
      buyerType: buyerType,
    );
  }

  UserModel copyWith({
    String? profileId,
    String? userId,
    String? fullName,
    String? phoneNumber,
    String? dateOfBirth,
    String? address,
    String? gender,
    int? pointBalance,
    String? rank,
    List<String>? roles,
    String? avatarUrl,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pointBalance: pointBalance ?? this.pointBalance,
      rank: rank ?? this.rank,
      roles: roles ?? this.roles,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
