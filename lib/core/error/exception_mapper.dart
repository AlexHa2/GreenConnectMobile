import 'dart:async';
import 'dart:io';

import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:dio/dio.dart';

Future<T> guard<T>(Future<T> Function() body) async {
  try {
    return await body();
  } catch (e) {
    throw _mapToAppException(e);
  }
}

AppException _mapToAppException(dynamic error) {
  if (error is DioException) {
    // Always use _mapBadResponse for badResponse to get proper status code
    if (error.type == DioExceptionType.badResponse) {
      return _mapBadResponse(error.response);
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.badResponse:
        return _mapBadResponse(error.response);

      case DioExceptionType.cancel:
        return UnknownException("Request Cancelled");

      case DioExceptionType.unknown:
      default:
        // Check for network-related errors
        if (error.error is SocketException) {
          return NetworkException();
        }
        // Check for SSL/TLS handshake errors by error message
        final errorMessage = error.message?.toLowerCase() ?? '';
        final errorString = error.toString().toLowerCase();
        if (errorMessage.contains('handshake') ||
            errorMessage.contains('connection terminated') ||
            errorMessage.contains('ssl') ||
            errorMessage.contains('tls') ||
            errorString.contains('handshake') ||
            errorString.contains('connection terminated')) {
          return NetworkException();
        }
        return UnknownException(error.message ?? "Unknown Error");
    }
  }

  if (error is FormatException) {
    return UnknownException("Format Error");
  }

  return UnknownException(error.toString());
}

AppException _mapBadResponse(Response? response) {
  final statusCode = response?.statusCode ?? 0;
  final data = response?.data;

  // Try to extract message from various possible fields in response
  String? serverMessage;
  if (data is Map) {
    // Try common message fields
    if (data.containsKey('message')) {
      serverMessage = data['message']?.toString();
    } else if (data.containsKey('error')) {
      serverMessage = data['error']?.toString();
    } else if (data.containsKey('errorMessage')) {
      serverMessage = data['errorMessage']?.toString();
    } else if (data.containsKey('errors')) {
      final errors = data['errors'];
      
      // Handle errors as Map (validation errors like {FieldName: [error1, error2]})
      if (errors is Map) {
        final errorMessages = <String>[];
        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            // Take first error message from the list
            errorMessages.add(value[0].toString());
          } else if (value != null) {
            errorMessages.add(value.toString());
          }
        });
        
        if (errorMessages.isNotEmpty) {
          serverMessage = errorMessages.join(', ');
        }
      }
      // Handle errors as List
      else if (errors is List && errors.isNotEmpty) {
        final firstError = errors[0];
        if (firstError is Map && firstError.containsKey('message')) {
          serverMessage = firstError['message']?.toString();
        } else {
          serverMessage = firstError.toString();
        }
      }
    }
  }
  
  // Fallback to statusMessage if no message found
  serverMessage = serverMessage?.trim();
  if (serverMessage == null || serverMessage.isEmpty) {
    serverMessage = response?.statusMessage ?? "Unknown Error";
  }

  switch (statusCode) {
    case 400:
    case 404:
    case 409:
      return BusinessException(serverMessage, code: statusCode);

    case 401:
    case 403:
      return UnauthorizedException();

    case 500:
    case 502:
    case 503:
      return ServerException(serverMessage, code: statusCode);

    default:
      return UnknownException("[$statusCode] $serverMessage");
  }
}


