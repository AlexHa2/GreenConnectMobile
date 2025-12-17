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
        if (error.error is SocketException) {
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

  final serverMessage = (data is Map && data.containsKey('message'))
      ? data['message'].toString()
      : response?.statusMessage ?? "Unknown Error";

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
