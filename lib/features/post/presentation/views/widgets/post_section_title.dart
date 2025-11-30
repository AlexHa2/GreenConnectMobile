import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class PostSectionTitle extends StatelessWidget {
  final String title;

  const PostSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: spacing.screenPadding * 2,
      ),
    );
  }
}
