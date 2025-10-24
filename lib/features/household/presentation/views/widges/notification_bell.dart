import 'package:flutter/material.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';

class NotificationIconButton extends StatelessWidget {
  final int count;
  final VoidCallback? onPressed;

  const NotificationIconButton({super.key, this.count = 0, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final textTheme = theme.textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(spacing.screenPadding),
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_none,
            color: theme.iconTheme.color,
            size: spacing.screenPadding * 2,
          ),
          if (count > 0)
            Positioned(
              right: -spacing.screenPadding / 4,
              top: -spacing.screenPadding / 4,
              child: Container(
                padding: EdgeInsets.all(spacing.screenPadding / 4),
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  style: textTheme.labelSmall?.copyWith(
                    color: theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
