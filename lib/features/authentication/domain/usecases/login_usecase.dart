


import 'package:GreenConnectMobile/features/authentication/domain/entities/user.dart';
import 'package:GreenConnectMobile/features/authentication/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
