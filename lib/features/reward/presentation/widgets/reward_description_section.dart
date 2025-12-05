import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Description section for reward detail
class RewardDescriptionSection extends StatelessWidget {
  final String title;
  final String description;

  const RewardDescriptionSection({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        SizedBox(height: space * 0.5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(space * 1.5),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(space),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }
}
