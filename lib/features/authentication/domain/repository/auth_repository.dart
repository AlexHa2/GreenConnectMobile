

import 'package:GreenConnectMobile/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<List<User>> getListUser();
}
  