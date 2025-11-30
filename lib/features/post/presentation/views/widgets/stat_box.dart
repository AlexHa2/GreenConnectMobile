import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const StatBox({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    
    return Container(
      width: spacing.screenPadding * 8,
      padding: EdgeInsets.symmetric(vertical: spacing.screenPadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        boxShadow: [BoxShadow(color: theme.shadowColor)],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: spacing.screenPadding * 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
