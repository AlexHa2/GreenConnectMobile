import 'package:dio/dio.dart';
import 'package:green_connect_mb/core/config/env.dart';


class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Authorization': 'Bearer ${Env.apiKey}',
      },
    ),
  );
}
