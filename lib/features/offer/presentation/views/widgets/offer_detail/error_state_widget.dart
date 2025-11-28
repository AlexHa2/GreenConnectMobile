import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String error;
  final ThemeData theme;
  final double spacing;
  final S s;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.error,
    required this.theme,
    required this.spacing,
    required this.s,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.danger,
              ),
            ),
            SizedBox(height: spacing * 1.5),
            Text(
              s.something_went_wrong,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing * 0.5),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing * 1.5),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(s.try_again),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.scaffoldBackgroundColor,
                padding: EdgeInsets.symmetric(
                  horizontal: spacing * 1.5,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
