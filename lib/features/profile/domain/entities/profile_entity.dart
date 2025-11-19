import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';

class ProfileEntity extends UserEntity {
  final String profileId;
  final String dateOfBirth;
  final String address;
  final String gender;

  ProfileEntity({
    required this.profileId,
    required this.dateOfBirth,
    required this.address,
    required this.gender,
    required super.userId,
    required super.fullName,
    required super.phoneNumber,
    required super.pointBalance,
    required super.rank,
    required super.roles,
    super.avatarUrl,
  });
}
