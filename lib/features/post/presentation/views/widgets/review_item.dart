import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: spacing.screenPadding / 2),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

