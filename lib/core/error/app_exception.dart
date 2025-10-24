class AppException implements Exception {
  final String code; 
  final int? statusCode;

  const AppException(this.code, {this.statusCode});

  @override
  String toString() => 'AppException: $code (HTTP $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException() : super('network_error');
}

class ServerException extends AppException {
  const ServerException() : super('server_error');
}

class CacheException extends AppException {
  const CacheException() : super('cache_error');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('unauthorized');
}

class NotFoundException extends AppException {
  const NotFoundException() : super('not_found');
}
