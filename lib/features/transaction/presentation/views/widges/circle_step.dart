import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class CircleStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final ThemeData theme;

  const CircleStep({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? theme.primaryColor
        : theme.primaryColor.withValues(alpha: 0.3);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color,
          child: Icon(icon, color: theme.scaffoldBackgroundColor),
        ),
        SizedBox(height: space / 2),
        Text(
          label,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
