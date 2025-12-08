import 'package:GreenConnectMobile/core/config/env.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio _dio;
  final TokenStorageService _tokenStorage;

  ApiClient(this._tokenStorage) : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      headers: {'Content-Type': 'application/json'},
    );

    _dio.interceptors.addAll([
      if (kDebugMode)
        LogInterceptor(requestBody: true, responseBody: true, error: true),

      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _tokenStorage.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await _tokenStorage.clearAuthData();
            return handler.reject(error);
          }
          return handler.reject(error);
        },
      ),
    ]);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    return _dio.post(path, data: data, options: options);
  }

  Future<Response> patch(String path, {dynamic data, Options? options}) async {
    return _dio.patch(path, data: data, options: options);
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    return _dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    return _dio.delete(path, data: data, options: options);
  }

  /// Post request with multipart/form-data
  /// Used for file uploads
  Future<Response> postMultipart(
    String path,
    FormData formData, {
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: formData,
      options: options ??
          Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ),
    );
  }

  /// Patch request with multipart/form-data
  /// Used for updating with file uploads
  Future<Response> patchMultipart(
    String path,
    FormData formData, {
    Options? options,
  }) async {
    return _dio.patch(
      path,
      data: formData,
      options: options ??
          Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ),
    );
  }
}
