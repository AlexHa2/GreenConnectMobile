import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({
    super.key,
    required this.icon,
    required this.title,
    required this.onEdit,
    required this.child,
    this.isSubmitting = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onEdit;
  final Widget child;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    return Container(
      padding: EdgeInsets.all(spacing.screenPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              SizedBox(width: spacing.screenPadding / 2),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: isSubmitting ? null : onEdit,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.screenPadding / 2,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.edit, size: 16),
                    SizedBox(width: spacing.screenPadding / 4),
                    Text(s.update, style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.screenPadding),
          child,
        ],
      ),
    );
  }
}

