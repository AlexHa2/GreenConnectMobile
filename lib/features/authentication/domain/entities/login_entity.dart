import 'package:GreenConnectMobile/features/authentication/domain/entities/user_entity.dart';

class LoginEntity {
  final String accessToken;
  final UserEntity user;

  LoginEntity({required this.accessToken, required this.user});
}
