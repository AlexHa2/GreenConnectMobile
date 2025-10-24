import 'package:GreenConnectMobile/core/error/app_exception.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';

import 'package:flutter/widgets.dart';

String localizeError(BuildContext context, Exception e) {
  final s = S.of(context)!;

  if (e is AppException) {
    switch (e.code) {
      case 'network_error':
        return s.network_error;
      case 'server_error':
        return s.server_error;
      case 'cache_error':
        return s.cache_error;
      case 'unauthorized':
        return s.unauthorized;
      case 'not_found':
        return s.not_found;
      default:
        return s.unexpected_error;
    }
  }
  return s.unexpected_error;
}
