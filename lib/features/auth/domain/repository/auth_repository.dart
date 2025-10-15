import 'package:green_connect_mb/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<List<User>> getListUser();
}
