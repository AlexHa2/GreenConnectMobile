import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class CustomButtonDanger extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Icon icon;
  const CustomButtonDanger({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.primaryColorLight,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.screenPadding * 3,
          vertical: spacing.screenPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.screenPadding),
        ),
        elevation: 2,
      ),
    );
  }
}
