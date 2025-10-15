import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_dto.dart';

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
