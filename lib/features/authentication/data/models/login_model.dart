// lib/data/models/login_model.dart

import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/authentication/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({required super.accessToken, required super.user});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json['accessToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'user': (user as UserModel).toJson()};
  }
}
