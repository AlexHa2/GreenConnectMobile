import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final textTheme = Theme.of(context).textTheme;

    final notifications = [
      NotificationItem(
        icon: Icons.card_giftcard,
        title: "Your eco-friendly purchase earned you 50 points!",
        time: "2 minutes ago",
        tag: "Eco Reward",
        tagColor: AppColors.primary,
      ),
      NotificationItem(
        icon: Icons.card_giftcard,
        title: "New eco-challenge available",
        time: "Yesterday",
        tag: "Eco Reward",
        tagColor: AppColors.primary,
      ),
      NotificationItem(
        icon: Icons.info_outline,
        title: "Payment successful - Order #PR0111",
        time: "1 hour ago",
      ),
      NotificationItem(
        icon: Icons.info_outline,
        title: "Refund processed - Order #PR0112",
        time: "Yesterday",
      ),
      NotificationItem(
        icon: Icons.notifications_none,
        title: "System maintenance scheduled",
        time: "Yesterday",
      ),
      NotificationItem(
        icon: Icons.notifications_none,
        title: "New privacy policy update",
        time: "2 days ago",
      ),
      NotificationItem(
        icon: Icons.notifications_none,
        title: "New privacy policy update",
        time: "2 days ago",
      ),
    ];
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.notifications),
        leading: BackButton(
          color: theme.textTheme.bodyLarge?.color,
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.textTheme.bodyLarge?.color),
            onPressed: () {
              // TODO: add refresh logic
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.screenPadding.toDouble()),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.screenPadding),
              ),
              margin: EdgeInsets.symmetric(vertical: spacing.screenPadding / 2),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.screenPadding,
                  vertical: spacing.screenPadding,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      item.icon,
                      color: item.tagColor ?? AppColors.textSecondary,
                      size: 26,
                    ),
                    SizedBox(width: spacing.screenPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: spacing.screenPadding / 2),
                          Text(item.time, style: textTheme.labelLarge),
                          if (item.tag != null) ...[
                            SizedBox(height: spacing.screenPadding / 2),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    (item.tagColor ??
                                    AppColors.primary.withValues(alpha: 0.9)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing.screenPadding / 2,
                                vertical: spacing.screenPadding / 4,
                              ),
                              child: Text(
                                item.tag!,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: theme.scaffoldBackgroundColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationItem {
  final IconData icon;
  final String title;
  final String time;
  final String? tag;
  final Color? tagColor;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.time,
    this.tag,
    this.tagColor,
  });
}
