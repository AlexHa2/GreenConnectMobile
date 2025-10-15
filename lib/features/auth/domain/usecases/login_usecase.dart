

import 'package:green_connect_mb/features/auth/domain/entities/user.dart';
import 'package:green_connect_mb/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
