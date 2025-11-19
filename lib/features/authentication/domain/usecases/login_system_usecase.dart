import 'package:GreenConnectMobile/features/authentication/domain/entities/login_entity.dart';
import 'package:GreenConnectMobile/features/authentication/domain/repository/auth_repository.dart';

class LoginSystemUsecase {
  final AuthRepository repository;

  LoginSystemUsecase({required this.repository});

  Future<LoginEntity> call({required String tokenId}) async {
    return repository.loginSystem(tokenId: tokenId);
  }
}
