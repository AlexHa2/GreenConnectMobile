// lib/data/models/user_model.dart
import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    super.profileId,
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

  @override
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      profileId: json['profileId'],
      // Support both 'id' (from API) and 'userId' (from storage)
      userId: json['userId'] ?? json['id'] ?? '',
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

  UserEntity toEntity() {
    return UserEntity(
      profileId: profileId,
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

  UserModel copyWith({
    String? profileId,
    String? userId,
    String? fullName,
    String? phoneNumber,
    String? dateOfBirth,
    String? address,
    String? gender,
    int? pointBalance,
    int? creditBalance,
    String? rank,
    List<String>? roles,
    String? avatarUrl,
    String? buyerType,
    String? bankCode,
    String? bankAccountNumber,
    String? bankAccountName,
  }) {
    return UserModel(
      profileId: profileId ?? this.profileId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      pointBalance: pointBalance ?? this.pointBalance,
      creditBalance: creditBalance ?? this.creditBalance,
      rank: rank ?? this.rank,
      roles: roles ?? this.roles,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      buyerType: buyerType ?? this.buyerType,
      bankCode: bankCode ?? this.bankCode,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankAccountName: bankAccountName ?? this.bankAccountName,
    );
  }
}
