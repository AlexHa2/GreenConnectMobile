import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

enum ToastType { success, error, warning, info }

class CustomToast {
  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color bgColor;
    Color iconColor;
    IconData icon;

    // final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    switch (type) {
      case ToastType.success:
        bgColor = theme.scaffoldBackgroundColor;
        iconColor = theme.primaryColor;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        bgColor = theme.scaffoldBackgroundColor;
        iconColor = AppColors.danger;
        icon = Icons.error_outline;
        break;
      case ToastType.warning:
        bgColor = theme.scaffoldBackgroundColor;
        iconColor = AppColors.warning;
        icon = Icons.warning_amber_rounded;
        break;
      case ToastType.info:
        bgColor = theme.scaffoldBackgroundColor;
        iconColor = theme.colorScheme.onSurface;
        icon = Icons.info_outline;
        break;
    }

    showOverlayNotification((context) {
      return SafeArea(
        child: SlideDismissible(
          key: ValueKey(message),
          direction: DismissDirection.up,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
                border: type != ToastType.info
                    ? Border.all(color: iconColor.withValues(alpha: 0.1))
                    : null,
              ),
              child: Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => OverlaySupportEntry.of(context)?.dismiss(),
                    child: Icon(
                      Icons.close,
                      color: iconColor.withValues(alpha: 0.5),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }, duration: duration);
  }
}
