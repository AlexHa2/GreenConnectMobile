import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class SubWidge extends StatelessWidget {
  final String label;
  final String value;
  const SubWidge({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: space * 1.5,
        horizontal: space * 2,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: space / 3),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
