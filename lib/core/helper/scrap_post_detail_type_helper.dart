import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class ScrapPostDetailTypeHelper {
  static String getLocalizedType(BuildContext context, ScrapPostDetailType type) {
    final s = S.of(context)!;
    switch (type) {
      case ScrapPostDetailType.sale:
        return s.scrap_type_sale;
      case ScrapPostDetailType.donation:
        return s.scrap_type_donation;
      case ScrapPostDetailType.service:
        return s.scrap_type_service;
    }
  }
}
