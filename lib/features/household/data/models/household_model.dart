import 'package:GreenConnectMobile/features/household/domain/entities/household_entity.dart';

class HouseholdModel extends HouseholdEntity {
  HouseholdModel({
    required super.id,
    required super.fullName,
    required super.phoneNumber,
    required super.pointBalance,
    required super.rank,
    required super.roles,
    required super.avatarUrl,
  });

  factory HouseholdModel.fromJson(Map<String, dynamic> json) {
    return HouseholdModel(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      pointBalance: json['pointBalance'],
      rank: json['rank'],
      roles: List<String>.from(json['roles']),
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'pointBalance': pointBalance,
    'rank': rank,
    'roles': roles,
    'avatarUrl': avatarUrl,
  };

  HouseholdEntity toEntity() {
    return HouseholdEntity(
      id: id,
      fullName: fullName,
      phoneNumber: phoneNumber,
      pointBalance: pointBalance,
      rank: rank,
      roles: roles,
      avatarUrl: avatarUrl,
    );
  }
}
