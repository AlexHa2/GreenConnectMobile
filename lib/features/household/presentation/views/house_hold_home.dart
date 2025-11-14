import 'package:GreenConnectMobile/features/household/presentation/views/widges/message.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/notification_bell.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/widges/post_item.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HouseHoldHome extends StatefulWidget {
  const HouseHoldHome({super.key});

  @override
  State<HouseHoldHome> createState() => _HouseHoldHomeState();
}

class _HouseHoldHomeState extends State<HouseHoldHome> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    const logo = 'assets/images/user_image.png';
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 🔹 Header
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            expandedHeight: spacing.screenPadding * 6,
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
                          backgroundImage: const AssetImage(logo),
                        ),
                        SizedBox(width: spacing.screenPadding),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Hà Thanh Phong Hà Thanh Phong Hà Thanh Phong Hà Thanh Phong",
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

                  // Icon bell
                  NotificationIconButton(
                    count: 1,
                    onPressed: () {
                      context.go('/notifications');
                    },
                  ),
                  SizedBox(width: spacing.screenPadding),
                  MessageIconButton(
                    count: 2,
                    onPressed: () {
                      context.go('/list-message');
                    },
                  ),
                ],
              ),
            ),
          ),

          // 🔹 scroll content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(spacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: spacing.screenPadding * 2),

                  Container(
                    padding: EdgeInsets.all(spacing.screenPadding * 2),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context)!.your_impact,
                                  style: textTheme.titleLarge?.copyWith(
                                    color: theme.scaffoldBackgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: spacing.screenPadding * 2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  S.of(context)!.keep_your_tree,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: theme.scaffoldBackgroundColor,
                                    fontSize: spacing.screenPadding,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.eco,
                              color: theme.scaffoldBackgroundColor,
                              size: 48,
                            ),
                          ],
                        ),

                        SizedBox(height: spacing.screenPadding * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "150 ${S.of(context)!.points}",
                              style: textTheme.bodyMedium?.copyWith(
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                            Text(
                              "500 ${S.of(context)!.points}",
                              style: textTheme.bodyMedium?.copyWith(
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: 150 / 500,
                          backgroundColor: theme.scaffoldBackgroundColor
                              .withValues(alpha: 0.3),
                          color: theme.scaffoldBackgroundColor,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: spacing.screenPadding * 2.5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox(
                        context,
                        "112",
                        S.of(context)!.accepted,
                        AppColors.primary,
                      ),
                      _buildStatBox(
                        context,
                        "110",
                        "${S.of(context)!.completed} ",
                        AppColors.primary,
                      ),
                      _buildStatBox(
                        context,
                        "144",
                        "${S.of(context)!.available} ",
                        AppColors.warning,
                      ),
                    ],
                  ),

                  SizedBox(height: spacing.screenPadding * 2.5),

                  // ===== Create New Post =====
                  GradientButton(
                    text: '${S.of(context)!.create_new} ${S.of(context)!.post}',
                    onPressed: () {
                      context.push('/create-post');
                    },
                    icon: const Icon(Icons.add),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    S.of(context)!.my_recycling_post,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: spacing.screenPadding * 2,
                    ),
                  ),
                  SizedBox(height: spacing.screenPadding * 2),

                  const PostItem(
                    title: "Plastic Bottles Collection",
                    desc: "he li a meo meo meo",
                    time: "9 AM - 5 PM",
                    status: "Accepted",
                    color: AppColors.primary,
                  ),
                  const PostItem(
                    title: "Plastic Bottles Collection",
                    desc: "he li a meo meo meo",
                    time: "9 AM - 5 PM",
                    status: "Available",
                    color: AppColors.warning,
                  ),
                  const PostItem(
                    title: "Plastic Bottles Collection",
                    desc: "he li a meo meo meo",
                    time: "9 AM - 5 PM",
                    status: "Rejected",
                    color: AppColors.danger,
                  ),

                  SizedBox(height: spacing.screenPadding),
                  InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(spacing.screenPadding / 2),
                    ),
                    onTap: () {
                      context.go('/list-post');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          S.of(context)!.see_all_posts,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Container(
      width: spacing.screenPadding * 8,
      padding: EdgeInsets.symmetric(vertical: spacing.screenPadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        boxShadow: [BoxShadow(color: theme.shadowColor)],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: spacing.screenPadding * 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
