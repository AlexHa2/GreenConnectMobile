import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/verification_entity.dart';

abstract class ProfileRepository {
  Future<String> verifyUser(VerificationEntity verify);
  Future<ProfileEntity> getMe();
  Future<ProfileEntity> updateMe(UserUpdateEntity update);
  Future<bool> updateAvatar(String avatarUrl);
  Future<String> updateVerification(VerificationEntity verify);
}
