import 'package:green_connect_mb/features/auth/domain/entities/user.dart';
import 'package:green_connect_mb/features/auth/domain/repository/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<List<User>> call() {
    return repository.getListUser();
  }
}
