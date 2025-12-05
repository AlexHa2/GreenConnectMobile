import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatePostButton extends StatelessWidget {
  const CreatePostButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final s = S.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.screenPadding),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
        child: InkWell(
          onTap: () => context.push('/create-post'),
          borderRadius: BorderRadius.circular(spacing.screenPadding),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.screenPadding * 1.5,
              vertical: spacing.screenPadding * 1.125,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(spacing.screenPadding),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(spacing.screenPadding / 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(spacing.screenPadding),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                SizedBox(width: spacing.screenPadding),
                Text(
                  '${s.create_new} ${s.post}',
                  style: textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
