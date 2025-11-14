import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class MessageIconButton extends StatelessWidget {
  final int count;
  final VoidCallback? onPressed;

  const MessageIconButton({super.key, this.count = 0, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final textTheme = theme.textTheme;

    final String displayCount = (count > 9) ? '9+' : count.toString();
    return InkWell(
      borderRadius: BorderRadius.circular(spacing.screenPadding),
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.message_outlined,
            color: theme.iconTheme.color,
            size: spacing.screenPadding * 2,
          ),
          if (count > 0)
            Positioned(
              right: -spacing.screenPadding / 4,
              top: -spacing.screenPadding / 4,
              child: Container(
                padding: EdgeInsets.all(spacing.screenPadding / 8),
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  displayCount,
                  style: textTheme.labelSmall?.copyWith(
                    color: theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.normal,
                    fontSize: spacing.screenPadding / 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
