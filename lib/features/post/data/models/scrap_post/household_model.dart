// household_model.dart

import 'package:GreenConnectMobile/features/post/domain/entities/household_entity.dart';

class HouseholdModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final int pointBalance;
  final int creditBalance;
  final String rank;
  final List<String> roles;
  final String? avatarUrl;

  HouseholdModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.pointBalance,
    required this.creditBalance,
    required this.rank,
    required this.roles,
    this.avatarUrl,
  });

  factory HouseholdModel.fromJson(Map<String, dynamic> json) {
    return HouseholdModel(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      pointBalance: json['pointBalance'] ?? 0,
      creditBalance: json['creditBalance'] ?? 0,
      rank: json['rank'],
      roles: List<String>.from(json['roles'] ?? []),
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'pointBalance': pointBalance,
      'creditBalance': creditBalance,
      'rank': rank,
      'roles': roles,
      'avatarUrl': avatarUrl,
    };
  }

  HouseholdEntity toEntity() {
    return HouseholdEntity(
      id: id,
      fullName: fullName,
      phoneNumber: phoneNumber,
      pointBalance: pointBalance,
      creditBalance: creditBalance,
      rank: rank,
      roles: roles,
      avatarUrl: avatarUrl,
    );
  }
}
