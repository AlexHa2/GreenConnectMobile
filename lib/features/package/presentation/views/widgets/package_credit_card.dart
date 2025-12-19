import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class CreditCard extends StatelessWidget {
  final dynamic user;
  const CreditCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final space = theme.extension<AppSpacing>()!.screenPadding;
    return Container(
      padding: EdgeInsets.all(space * 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space * 2),
        gradient: AppColors.linearSecondary,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: isSmallScreen ? 26 : 32,
            backgroundImage:
                (user?.avatarUrl != null && user.avatarUrl.isNotEmpty)
                ? NetworkImage(user.avatarUrl)
                : null,
            backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
            child: user?.avatarUrl == null
                ? Icon(
                    Icons.person,
                    size: isSmallScreen ? 26 : 32,
                    color: theme.primaryColor,
                  )
                : null,
          ),
          SizedBox(width: space),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.fullName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isSmallScreen
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                ),
                const SizedBox(height: 6),
                Text('Điểm hiện có', style: theme.textTheme.bodySmall),

                /// 🔥 ANIMATION
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: user?.creditBalance ?? 0),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return Text(
                      value.toString(),
                      style:
                          (isSmallScreen
                                  ? theme.textTheme.titleLarge
                                  : theme.textTheme.headlineMedium)
                              ?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Icon(Icons.monetization_on, size: 34, color: AppColors.warning),
        ],
      ),
    );
  }
}
