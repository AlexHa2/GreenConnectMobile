import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ComplaintBottomActions extends StatelessWidget {
  final String cancelText;
  final String submitText;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final bool isSubmitting;
  final Color? submitButtonColor;
  final IconData? submitIcon;

  const ComplaintBottomActions({
    super.key,
    required this.cancelText,
    required this.submitText,
    required this.onCancel,
    required this.onSubmit,
    this.isSubmitting = false,
    this.submitButtonColor,
    this.submitIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Container(
      padding: EdgeInsets.all(space * 1.5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          top: BorderSide(color: theme.dividerColor, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isSubmitting ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: space),
                  side: BorderSide(color: theme.dividerColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(space),
                  ),
                ),
                child: Text(cancelText),
              ),
            ),
            SizedBox(width: space),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: isSubmitting ? null : onSubmit,
                icon: Icon(submitIcon ?? Icons.check_circle_outline),
                label: Text(submitText),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: space),
                  backgroundColor: submitButtonColor ?? theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(space),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
