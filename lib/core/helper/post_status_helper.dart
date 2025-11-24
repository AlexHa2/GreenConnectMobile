import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class PostStatusHelper {
  static Color getStatusColor(BuildContext context, PostStatus status) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    switch (status) {
      case PostStatus.open:
        return theme.primaryColor;

      case PostStatus.partiallyBooked:
        final partialColor = isLight
            ? AppColors.warningUpdate
            : AppColorsDark.warningUpdate;
        return partialColor.withValues(alpha: 0.8);

      case PostStatus.fullyBooked:
        final fullColor = isLight ? AppColors.warning : AppColorsDark.warning;
        return fullColor;

      case PostStatus.completed:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);

      case PostStatus.canceled:
        final dangerColor = isLight ? AppColors.danger : AppColorsDark.danger;
        return dangerColor;
    }
  }

  static String getLocalizedStatus(BuildContext context, PostStatus status) {
    final t = S.of(context)!;

    switch (status) {
      case PostStatus.open:
        return t.open;

      case PostStatus.partiallyBooked:
        return t.partially_booked;

      case PostStatus.fullyBooked:
        return t.fully_booked;

      case PostStatus.completed:
        return t.completed;

      case PostStatus.canceled:
        return t.canceled;
    }
  }

  static bool showTransactionAction(String status) {
    return status.toLowerCase() == "accepted";
  }
}
