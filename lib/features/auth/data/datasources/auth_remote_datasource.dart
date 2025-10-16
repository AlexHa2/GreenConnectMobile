import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:dio/dio.dart';

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
