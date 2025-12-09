abstract class AppException implements Exception {
  final String?
  message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});
}
class NetworkException extends AppException {
  NetworkException() : super("Network Error");
}
class UnauthorizedException extends AppException {
  UnauthorizedException() : super("Unauthorized");
}
class ServerException extends AppException {
  ServerException(super.msg, {int? code}) : super(statusCode: code);
}
class BusinessException extends AppException {
  BusinessException(super.msg, {int? code}) : super(statusCode: code);
}

class UnknownException extends AppException {
  UnknownException(super.msg);
}
