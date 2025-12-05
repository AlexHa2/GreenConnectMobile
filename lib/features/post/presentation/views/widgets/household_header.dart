import 'package:GreenConnectMobile/features/post/presentation/views/widgets/notification_bell.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HouseholdHeader extends StatelessWidget {
  final UserModel user;
  final String displayName;
  final int unreadCount;

  const HouseholdHeader({
    super.key,
    required this.user,
    required this.displayName,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    const logo = 'assets/images/user_image.png';

    return SliverAppBar(
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      expandedHeight: spacing.screenPadding * 6,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: spacing.screenPadding,
          right: spacing.screenPadding,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: spacing.screenPadding * 1.5,
                    backgroundImage: user.avatarUrl != null
                        ? NetworkImage(user.avatarUrl!)
                        : const AssetImage(logo) as ImageProvider,
                    backgroundColor: theme.primaryColor.withValues(alpha: 0.4),
                  ),
                  SizedBox(width: spacing.screenPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        Text(
                          S.of(context)!.make_an_impact,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            NotificationIconButton(
              count: unreadCount,
              onPressed: () => context.push('/notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
