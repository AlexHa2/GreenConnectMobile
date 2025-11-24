import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class TimeAgoHelper {
  static String format(BuildContext context, DateTime time) {
    final s = S.of(context)!;
    final now = DateTime.now();
    final diff = now.difference(time);

    // < 1 
    if (diff.inMinutes < 1) {
      return s.just_now;
    }

    // < 1 
    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} ${s.minutes_ago}";
    }

    // < 24 
    if (diff.inHours < 24) {
      return "${diff.inHours} ${s.hours_ago}";
    }


    if (diff.inDays == 1) {
      return s.yesterday;
    }

    if (diff.inDays < 7) {
      return "${diff.inDays} ${s.days_ago}";
    }

    // >= 7  -> dd/MM/yyyy
    return "${time.day.toString().padLeft(2, '0')}/"
        "${time.month.toString().padLeft(2, '0')}/"
        "${time.year}";
  }
}
