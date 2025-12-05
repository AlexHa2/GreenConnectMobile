import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';

class ProfileEntity extends UserEntity {
  ProfileEntity({
    required String profileId,
    required String userId,
    required String fullName,
    required String phoneNumber,
    String? dateOfBirth,
    String? address,
    String? gender,
    required int pointBalance,
    int? creditBalance,
    required String rank,
    required List<String> roles,
    String? avatarUrl,
    String? buyerType,
    String? bankCode,
    String? bankAccountNumber,
    String? bankAccountName,
  }) : super(
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
