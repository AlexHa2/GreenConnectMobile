import 'package:GreenConnectMobile/core/config/env.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Callback for upload/analysis progress
/// [sent] - bytes sent
/// [total] - total bytes to send
/// [progress] - progress percentage (0.0 to 1.0)
typedef UploadProgressCallback = void Function(int sent, int total, double progress);

class ApiClient {
  final Dio _dio;
  final TokenStorageService _tokenStorage;

  ApiClient(this._tokenStorage) : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
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

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
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
    // Dio automatically sets Content-Type with boundary when FormData is used
    return _dio.post(
      path,
      data: formData,
      options: options,
    );
  }

  /// Patch request with multipart/form-data
  /// Used for updating with file uploads
  Future<Response> patchMultipart(
    String path,
    FormData formData, {
    Options? options,
  }) async {
    // Dio automatically sets Content-Type with boundary when FormData is used
    return _dio.patch(
      path,
      data: formData,
      options: options,
    );
  }

  /// Post request with multipart/form-data and extended timeout
  /// Used for long-running operations like AI analysis
  /// 
  /// Features:
  /// - Extended timeout (default: 10 minutes)
  /// - Progress callback for upload tracking
  /// - Automatic retry with exponential backoff on timeout/network errors
  /// - Ensures connection stays open until full response is received
  /// - Uses separate Dio instance with extended timeouts to avoid affecting other requests
  /// - Recreates FormData for each retry (FormData can only be used once)
  /// 
  /// Parameters:
  /// - [path]: API endpoint path
  /// - [formDataFactory]: Function that creates FormData (called for each retry attempt)
  /// - [timeout]: Request timeout (default: 10 minutes)
  /// - [maxRetries]: Maximum number of retry attempts (default: 3)
  /// - [retryDelay]: Initial delay before retry (default: 2 seconds)
  /// - [onProgress]: Callback for upload progress (sent, total, progress)
  /// - [options]: Additional Dio options
  Future<Response> postMultipartWithLongTimeout(
    String path,
    FormData Function() formDataFactory, {
    Duration? timeout,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    UploadProgressCallback? onProgress,
    Options? options,
  }) async {
    final extendedTimeout = timeout ?? const Duration(minutes: 10);
    
    // Create a separate Dio instance for long-running requests
    // This ensures extended timeouts don't affect other requests
    final longRunningDio = Dio(BaseOptions(
      baseUrl: _dio.options.baseUrl,
      connectTimeout: extendedTimeout,
      sendTimeout: extendedTimeout,
      receiveTimeout: extendedTimeout,
      headers: {
        'Content-Type': 'multipart/form-data',
        ...?options?.headers,
      },
    ));

    // Setup interceptors for auth and logging
    longRunningDio.interceptors.addAll([
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

    // Create new request options
    final requestOptions = Options(
      followRedirects: true,
      validateStatus: (status) => status != null && status < 500,
      extra: options?.extra,
      responseType: options?.responseType ?? ResponseType.json,
      contentType: options?.contentType,
    );

    int attempt = 0;
    DioException? lastError;
    Response? successfulResponse;

    try {
      // Retry loop with exponential backoff
      while (attempt <= maxRetries) {
        try {
          // Create fresh FormData for each attempt (FormData can only be used once)
          final formData = formDataFactory();
          
          // Setup progress callback if provided
          ProgressCallback? dioProgressCallback;
          if (onProgress != null) {
            dioProgressCallback = (sent, total) {
              final progress = total > 0 ? sent / total : 0.0;
              onProgress(sent, total, progress);
            };
          }

          // Make the request and ensure we wait for the complete response
          final response = await longRunningDio.post(
            path,
            data: formData,
            options: requestOptions,
            onSendProgress: dioProgressCallback,
          );
          
          // Verify we have a complete response
          if (response.statusCode == null) {
            throw DioException(
              requestOptions: RequestOptions(path: path),
              type: DioExceptionType.badResponse,
              error: 'Response received but status code is null',
            );
          }
          
          // Success - store response and break out of retry loop
          successfulResponse = response;
          debugPrint('✅ [ANALYZE SCRAP] Response received successfully: ${response.statusCode}');
          break;
        } on DioException catch (e) {
          lastError = e;
          attempt++;

          // Log the error for debugging
          debugPrint(
            '❌ [ANALYZE SCRAP] Attempt $attempt/$maxRetries failed. '
            'Error type: ${e.type}, Message: ${e.message}',
          );

          // Check if error is retryable
          final isRetryable = _isRetryableError(e);
          
          if (!isRetryable || attempt > maxRetries) {
            // Not retryable or max retries reached
            debugPrint('❌ [ANALYZE SCRAP] Not retrying. isRetryable: $isRetryable, attempt: $attempt, maxRetries: $maxRetries');
            break;
          }

          // Calculate exponential backoff delay
          final delay = Duration(
            milliseconds: (retryDelay.inMilliseconds * (1 << (attempt - 1))).clamp(
              retryDelay.inMilliseconds,
              const Duration(seconds: 30).inMilliseconds, // Max 30 seconds
            ),
          );

          debugPrint(
            '🔄 [RETRY] Attempt $attempt/$maxRetries failed. '
            'Retrying in ${delay.inSeconds}s... Error: ${e.message}',
          );

          // Wait before retry
          await Future.delayed(delay);
        } catch (e) {
          // Non-DioException - don't retry
          debugPrint('❌ [ANALYZE SCRAP] Non-DioException: $e');
          lastError = DioException(
            requestOptions: RequestOptions(path: path),
            error: e.toString(),
          );
          break;
        }
      }

      // Return successful response if we have one
      if (successfulResponse != null) {
        return successfulResponse;
      }

      // All retries exhausted or non-retryable error
      throw lastError ?? DioException(
        requestOptions: RequestOptions(path: path),
        error: 'Max retries ($maxRetries) exceeded',
      );
    } finally {
      // Always clean up the Dio instance
      longRunningDio.close(force: true);
    }
  }

  /// Check if error is retryable
  bool _isRetryableError(DioException error) {
    // Retry on timeout errors
    if (error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionTimeout) {
      return true;
    }

    // Retry on connection errors
    if (error.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on unknown errors that are connection-related
    // This includes "Connection closed before full header was received"
    // Note: "FormData has already been finalized" should not happen now since we recreate it,
    // but we'll handle it just in case
    if (error.type == DioExceptionType.unknown) {
      final errorMessage = error.message?.toLowerCase() ?? '';
      final errorString = error.error?.toString().toLowerCase() ?? '';
      
      // Check for connection-related error messages
      if (errorMessage.contains('connection closed') ||
          errorMessage.contains('connection error') ||
          errorMessage.contains('connection timeout') ||
          errorString.contains('connection closed') ||
          errorString.contains('connection error') ||
          errorString.contains('httpException') ||
          errorString.contains('formdata has already been finalized')) {
        return true;
      }
    }

    // Retry on 5xx server errors (except 501, 505)
    final statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 500 && statusCode < 600) {
      if (statusCode != 501 && statusCode != 505) {
        return true;
      }
    }

    // Retry on 408 Request Timeout
    if (statusCode == 408) {
      return true;
    }

    // Don't retry on other errors (4xx client errors, etc.)
    return false;
  }
}
