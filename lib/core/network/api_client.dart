import 'package:GreenConnectMobile/core/config/env.dart';
import 'package:dio/dio.dart';



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
