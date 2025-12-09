import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';

class ProfileEntity extends UserEntity {
  ProfileEntity({
    required String super.profileId,
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
}
