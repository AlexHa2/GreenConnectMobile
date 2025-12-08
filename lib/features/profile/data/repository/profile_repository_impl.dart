import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/verification_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource profileDataSource;

  ProfileRepositoryImpl(this.profileDataSource);

  @override
  Future<String> verifyUser(VerificationEntity verify) async {
    return guard(() async {
      return await profileDataSource.verifyUser(verify: verify);
    });
  }

  @override
  Future<ProfileEntity> getMe() async {
    return guard(() async {
      return await profileDataSource.getMe();
    });
  }

  @override
  Future<ProfileEntity> updateMe(UserUpdateEntity update) async {
    return guard(() async {
      return await profileDataSource.updateMe(update: update);
    });
  }
  
  @override
  Future<bool> updateAvatar(String avatarUrl) async {
    return guard(() async {
      return await profileDataSource.updateAvatar(avatarUrl: avatarUrl);
    });
  }

  @override
  Future<String> updateVerification(VerificationEntity verify) async {
    return guard(() async {
      return await profileDataSource.updateVerification(verify: verify);
    });
  }
}
