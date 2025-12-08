import 'package:GreenConnectMobile/features/collector/presentation/views/widgets/nearby_opportunities_map.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/notification_bell.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CollectorDashboard extends StatefulWidget {
  const CollectorDashboard({super.key});

  @override
  State<CollectorDashboard> createState() => _CollectorDashboardState();
}

class _CollectorDashboardState extends State<CollectorDashboard> {
  int _currentIndex = 0;

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
                                "Nguyễn Văn A",
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                              Text(
                                S.of(context)!.mobile_collector,
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
                    onPressed: () {
                      context.push('/notifications');
                    },
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Scroll content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(spacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: spacing.screenPadding * 2),

                  // ===== Stats Row 1 =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          "55",
                          S.of(context)!.completed_pickups,
                          AppColors.primary,
                          Icons.check_circle_outline,
                        ),
                      ),
                      SizedBox(width: spacing.screenPadding),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          "\$250.00",
                          S.of(context)!.earnings_today,
                          AppColors.warning,
                          Icons.attach_money,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacing.screenPadding),

                  // ===== Stats Row 2 =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          "\$1,250.00",
                          S.of(context)!.total_revenue,
                          AppColors.primary,
                          Icons.account_balance_wallet_outlined,
                        ),
                      ),
                      SizedBox(width: spacing.screenPadding),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          "145 Kg",
                          S.of(context)!.total_weight_collected,
                          AppColors.warningUpdate,
                          Icons.scale,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacing.screenPadding * 3),

                  // ===== Nearby Opportunities Map =====
                  NearbyOpportunitiesMap(
                    onTapMap: () {
                      context.push('/opportunities-map');
                    },
                    onBrowseAllJobs: () {
                      context.push('/browse-jobs');
                    },
                  ),

                  SizedBox(height: spacing.screenPadding * 3),

                  // ===== Recent Pickups Header =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context)!.recent_pickups,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: spacing.screenPadding * 2,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to all pickups
                        },
                        child: Text(
                          S.of(context)!.see_all,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacing.screenPadding),

                  // ===== Recent Pickups List =====
                  _buildPickupItem(
                    context,
                    title: "Plastic Bottles Collection",
                    location: "123 Green Avenue",
                    time: "08:30 AM",
                    amount: "\$45.00",
                    weight: "25 Kg",
                    status: S.of(context)!.completed,
                    color: AppColors.primary,
                  ),
                  _buildPickupItem(
                    context,
                    title: "Paper Recycling",
                    location: "456 Eco Street",
                    time: "10:15 AM",
                    amount: "\$38.50",
                    weight: "18 Kg",
                    status: S.of(context)!.completed,
                    color: AppColors.primary,
                  ),
                  _buildPickupItem(
                    context,
                    title: "Metal Scraps",
                    location: "789 Nature Road",
                    time: "02:00 PM",
                    amount: "\$62.00",
                    weight: "32 Kg",
                    status: S.of(context)!.in_progress,
                    color: AppColors.warning,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ===== Bottom Navigation =====
      bottomNavigationBar: CustomBottomNav(
        initialIndex: _currentIndex,
        items: [
          BottomNavItem(
            icon: Icons.home,
            label: S.of(context)!.home,
            onPressed: () => setState(() => _currentIndex = 0),
          ),
          BottomNavItem(
            icon: Icons.search,
            label: S.of(context)!.search,
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
          BottomNavItem(
            icon: Icons.shopping_cart_outlined,
            label: S.of(context)!.orders,
            onPressed: () {
              // TODO: Navigate to orders
            },
          ),
          BottomNavItem(
            icon: Icons.person_outline,
            label: S.of(context)!.profile,
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Container(
      padding: EdgeInsets.all(spacing.screenPadding * 2),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing.screenPadding * 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              Container(
                padding: EdgeInsets.all(spacing.screenPadding / 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: color,
                  size: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.screenPadding),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: spacing.screenPadding * 2,
            ),
          ),
          SizedBox(height: spacing.screenPadding / 3),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPickupItem(
    BuildContext context, {
    required String title,
    required String location,
    required String time,
    required String amount,
    required String weight,
    required String status,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Container(
      margin: EdgeInsets.only(bottom: spacing.screenPadding),
      padding: EdgeInsets.all(spacing.screenPadding * 1.5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing.screenPadding * 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.screenPadding,
                  vertical: spacing.screenPadding / 3,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(
                    spacing.screenPadding * 2,
                  ),
                ),
                child: Text(
                  status,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.screenPadding),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: theme.textTheme.bodySmall?.color,
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.screenPadding / 2),
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 16,
                color: theme.textTheme.bodySmall?.color,
              ),
              SizedBox(width: 4),
              Text(
                time,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: spacing.screenPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    amount,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.scale_outlined,
                    size: 16,
                    color: AppColors.warningUpdate,
                  ),
                  SizedBox(width: 4),
                  Text(
                    weight,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.warningUpdate,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

