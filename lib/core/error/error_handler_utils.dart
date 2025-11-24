import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

extension AppExceptionExtension on AppException {
  String toLocalizedMessage(BuildContext context) {
    final s = S.of(context)!;

    if (this is NetworkException) {
      return s.error_no_internet;
    }

    if (this is UnauthorizedException) {
      return s.error_session_expired;
    }

    if (this is ServerException) {
      return message ?? s.error_server_error;
    }

    if (this is BusinessException) {
      return message ?? s.error_unknown;
    }

    if (this is UnknownException) {
      return s.error_unknown;
    }

    return s.error_unknown;
  }
}
