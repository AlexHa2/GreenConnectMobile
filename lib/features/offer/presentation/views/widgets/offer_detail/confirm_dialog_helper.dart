import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ConfirmDialogHelper {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required bool isDestructive,
  }) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message, style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              s.cancel,
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive
                  ? AppColorsDark.danger
                  : theme.primaryColor,
              foregroundColor: theme.scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing / 2),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
