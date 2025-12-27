import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class NotificationIconButton extends StatelessWidget {
  final int count;
  final VoidCallback? onPressed;

  const NotificationIconButton({super.key, this.count = 0, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final textTheme = theme.textTheme;
    final scaler = MediaQuery.textScalerOf(context);

    final baseIconSize = scaler.scale(28);
    final iconSize = baseIconSize.clamp(26, 34).toDouble();
    final badgeFontSize = scaler.scale(12).clamp(10, 13).toDouble();
    final badgePadding = (badgeFontSize * 0.25).clamp(2, 4).toDouble();
    final badgeOffset = (iconSize * 0.15).clamp(3, 6).toDouble();

    final String displayCount = (count > 9) ? '9+' : count.toString();
    return InkWell(
      borderRadius: BorderRadius.circular(spacing.screenPadding),
      onTap: onPressed,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_none,
                color: theme.iconTheme.color,
                size: iconSize,
              ),
              if (count > 0)
                Positioned(
                  right: -badgeOffset,
                  top: -badgeOffset,
                  child: Container(
                    padding: EdgeInsets.all(badgePadding),
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      displayCount,
                      style: textTheme.labelSmall?.copyWith(
                        color: theme.scaffoldBackgroundColor,
                        fontWeight: FontWeight.normal,
                        fontSize: badgeFontSize,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
