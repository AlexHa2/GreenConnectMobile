import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Submit button with loading state
class SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final IconData icon;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.icon = Icons.send_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: spacing * 1.3),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing * 1.5),
          ),
          disabledBackgroundColor: theme.primaryColor.withValues(alpha: 0.5),
        ),
        child: isLoading
            ? SizedBox(
                height: spacing * 2,
                width: spacing * 2,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.scaffoldBackgroundColor,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: spacing * 2),
                  SizedBox(width: spacing * 0.8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: spacing * 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
