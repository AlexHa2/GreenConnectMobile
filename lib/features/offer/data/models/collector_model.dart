import 'package:GreenConnectMobile/features/offer/domain/entities/collector_entity.dart';

class CollectorModel {
  final String id;
  final String? fullName;
  final String? phoneNumber;
  final int pointBalance;
  final String rank;
  final List<String> roles;
  final String? avatarUrl;

  CollectorModel({
    required this.id,
    this.fullName,
    this.phoneNumber,
    required this.pointBalance,
    required this.rank,
    required this.roles,
    this.avatarUrl,
  });

  factory CollectorModel.fromJson(Map<String, dynamic> json) {
    return CollectorModel(
      id: json['id'] ?? '00000000-0000-0000-0000-000000000000',
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      pointBalance: json['pointBalance'] ?? 0,
      rank: json['rank'] ?? 'Bronze',
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'pointBalance': pointBalance,
      'rank': rank,
      'roles': roles,
      'avatarUrl': avatarUrl,
    };
  }

  CollectorEntity toEntity() {
    return CollectorEntity(
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
