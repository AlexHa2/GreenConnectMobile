

import 'package:GreenConnectMobile/features/auth/domain/entities/user.dart';
import 'package:GreenConnectMobile/features/auth/domain/repository/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<List<User>> call() {
    return repository.getListUser();
  }
}
