import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class PostDetailStatusHelper {
  static Color getStatusColor(BuildContext context, PostDetailStatus status) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    switch (status) {
      case PostDetailStatus.available:
        return theme.primaryColor;

      case PostDetailStatus.booked:
        final partialColor = isLight
            ? AppColors.warningUpdate
            : AppColorsDark.warningUpdate;
        return partialColor.withValues(alpha: 0.8);

      case PostDetailStatus.collected:
        final fullColor = isLight
            ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
            : theme.colorScheme.onSurface.withValues(alpha: 0.5);
        return fullColor;
    }
  }

  static String getLocalizedStatus(
    BuildContext context,
    PostDetailStatus status,
  ) {
    final t = S.of(context)!;

    switch (status) {
      case PostDetailStatus.available:
        return t.available;

      case PostDetailStatus.booked:
        return t.booked;

      case PostDetailStatus.collected:
        return t.collected;
    }
  }

  static bool showTransactionAction(String status) {
    return status.toLowerCase() == "accepted";
  }
}
