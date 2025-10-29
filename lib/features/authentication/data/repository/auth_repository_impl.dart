
import 'package:GreenConnectMobile/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:GreenConnectMobile/features/authentication/data/models/user_dto.dart';
import 'package:GreenConnectMobile/features/authentication/domain/entities/user.dart';
import 'package:GreenConnectMobile/features/authentication/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    final res = await remoteDataSource.login(email, password);
    return UserDto.fromJson(res.data).toEntity();
  }

  @override
  Future<List<User>> getListUser() {
    final res = remoteDataSource.getListUser();
    return res.then(
      (data) => data.map((e) => UserDto.fromJson(e).toEntity()).toList(),
    );
  }
}
