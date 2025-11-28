import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  String toLocalFormat(
    BuildContext context, {
    bool includeTime = true,
    bool? use24hFormat,
  }) {
    final String localeCode = Localizations.localeOf(context).toString();

    DateFormat formatter = DateFormat.yMMMd(localeCode);

    if (includeTime) {

      if (use24hFormat == true) {
        formatter = formatter.add_Hm();
      } else if (use24hFormat == false) {
        formatter = formatter.add_jm();
      } else {
        formatter = formatter.add_jm();
      }
    }

    return formatter.format(this);
  }

  String toCustomFormat({String locale = 'vi'}) {
    final dateStr = DateFormat.yMMMd(locale).format(this);
    final timeStr = DateFormat('HH:mm').format(this);

    return '$dateStr • $timeStr';
  }
}
