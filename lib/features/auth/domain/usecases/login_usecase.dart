


import 'package:GreenConnectMobile/features/auth/domain/entities/user.dart';
import 'package:GreenConnectMobile/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
