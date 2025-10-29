

import 'package:GreenConnectMobile/features/authentication/domain/entities/user.dart';
import 'package:GreenConnectMobile/features/authentication/domain/repository/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<List<User>> call() {
    return repository.getListUser();
  }
}
