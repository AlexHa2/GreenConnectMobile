import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Parse ISO string (UTC) from backend safely
  static DateTime fromBackend(String isoString) {
    // Parse UTC → convert to local time
    return DateTime.parse(isoString).toLocal();
  }

  /// Format theo locale + tùy chọn 12h / 24h
  String toLocalFormat(
    BuildContext context, {
    bool includeTime = true,
    bool? use24hFormat,
  }) {
    final String localeCode = Localizations.localeOf(context).toString();

    DateFormat formatter = DateFormat.yMMMd(localeCode);

    if (includeTime) {
      if (use24hFormat == true) {
        formatter = formatter.add_Hm(); // 24h
      } else {
        formatter = formatter.add_jm(); // 12h
      }
    }

    return formatter.format(this);
  }

  //Custom format: "08 Dec 2025 • 13:02"
  String toCustomFormat({String locale = 'vi'}) {
    final dateStr = DateFormat.yMMMd(locale).format(this);
    final timeStr = DateFormat('HH:mm').format(this);
    return '$dateStr • $timeStr';
  }
}
