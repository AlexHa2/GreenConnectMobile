import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(space),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: space * 1.5, horizontal: space),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(space),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.scaffoldBackgroundColor, size: 32),
            SizedBox(height: space / 2),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.scaffoldBackgroundColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
