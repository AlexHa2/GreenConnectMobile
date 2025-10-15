import 'package:dio/dio.dart';
import 'package:green_connect_mb/core/network/api_client.dart';


class AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSource(this.client);

  Future<Response> login(String email, String password) {
    return client.dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<List<dynamic>> getListUser() async {
    final response = await client.dio.get('/users');
    return response.data;
  }


}

