
import 'package:green_connect_mb/features/auth/domain/entities/user.dart';

class UserDto {
  final String id;
  final String email;
  final String name;
  final String token;

  UserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      token: json['token'],
    );
  }

  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        token: token,
      );
}
