import 'package:GreenConnectMobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/verification_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource profileDataSource;

  ProfileRepositoryImpl(this.profileDataSource);

  @override
  Future<String> verifyUser(VerificationEntity verify) {
    return profileDataSource.verifyUser(verify: verify);
  }

  @override
  Future<ProfileEntity> getMe() {
    return profileDataSource.getMe();
  }

  @override
  Future<ProfileEntity> updateMe(UserUpdateEntity update) {
    return profileDataSource.updateMe(update: update);
  }
  
  @override
  Future<bool> updateAvatar(String avatarUrl) {
    return profileDataSource.updateAvatar(avatarUrl: avatarUrl);
  }

  @override
  Future<String> updateVerification(VerificationEntity verify) {
    return profileDataSource.updateVerification(verify: verify);
  }
}
