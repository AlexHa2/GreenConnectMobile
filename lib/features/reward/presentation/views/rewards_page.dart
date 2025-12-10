import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/features/reward/presentation/providers/reward_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Main Rewards Page
/// Displays user's reward points, quick actions, and recent activities
class RewardsPage extends ConsumerStatefulWidget {
  final bool? isCollectorView;
  const RewardsPage({super.key, this.isCollectorView = false});

  @override
  ConsumerState<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends ConsumerState<RewardsPage> {
  int pointBalance = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(profileViewModelProvider.notifier).getMe();
      final profileState = ref.read(profileViewModelProvider);
      setState(() {
        pointBalance = profileState.user?.pointBalance ?? 0;
      });
      ref.read(rewardViewModelProvider.notifier).fetchRewardHistory();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(profileViewModelProvider.notifier).getMe();
    final profileState = ref.read(profileViewModelProvider);
    setState(() {
      pointBalance = profileState.user?.pointBalance ?? 0;
    });
    await ref.read(rewardViewModelProvider.notifier).fetchRewardHistory();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final rewardState = ref.watch(rewardViewModelProvider);

    final recentHistory = rewardState.rewardHistory?.take(5).toList() ?? [];
    final isCollectorView = widget.isCollectorView != null;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            // App Bar with gradient - No back button since we have navbar
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.linearSecondary,
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        // Modern back button for collector view
                        if (!isCollectorView)
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(32),
                                onTap: () => context.pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface.withValues(
                                      alpha: 0.85,
                                    ),
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_rounded,
                                        color: theme.colorScheme.primary,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        S.of(context)!.back,
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Decorative circles
                        Positioned(
                          top: -50,
                          right: -30,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  theme.primaryColor.withValues(alpha: 0.15),
                                  theme.primaryColor.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -60,
                          left: -50,
                          child: Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  theme.primaryColor.withValues(alpha: 0.12),
                                  theme.primaryColor.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Floating particles
                        Positioned(
                          top: 100,
                          right: 60,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.warning.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 160,
                          left: 80,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        // Content
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: space * 3.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Points icon with modern design
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.warning.withValues(
                                          alpha: 0.9,
                                        ),
                                        AppColors.warning.withValues(
                                          alpha: 0.7,
                                        ),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.warning.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 24,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.stars_rounded,
                                    size: 48,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Points display with modern styling
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: AppColors.linearPrimary.colors,
                                  ).createShader(bounds),
                                  child: Text(
                                    '$pointBalance',
                                    style: theme.textTheme.displayLarge
                                        ?.copyWith(
                                          color: theme.scaffoldBackgroundColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 72,
                                          height: 1,
                                          letterSpacing: -2,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Subtitle
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_rounded,
                                        size: 16,
                                        color: theme.primaryColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        s.available_points,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(space),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.quick_actions,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: space),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.card_giftcard_rounded,
                            label: s.redeem_rewards,
                            gradient: LinearGradient(
                              colors: [
                                theme.primaryColor,
                                theme.primaryColor.withValues(alpha: 0.7),
                              ],
                            ),
                            onTap: () => context.push('/reward-store'),
                          ),
                        ),
                        SizedBox(width: space),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.redeem_rounded,
                            label: s.my_rewards,
                            gradient: LinearGradient(
                              colors: [
                                theme.primaryColor,
                                theme.primaryColor.withValues(alpha: 0.7),
                              ],
                            ),
                            onTap: () => context.push('/my-rewards'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: space),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.history_rounded,
                            label: s.transaction_history,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.warning,
                                AppColors.warning.withValues(alpha: 0.7),
                              ],
                            ),
                            onTap: () => context.push('/reward-history'),
                          ),
                        ),
                        SizedBox(width: space),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.leaderboard_rounded,
                            label: s.leaderboard,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.info,
                                AppColors.info.withValues(alpha: 0.7),
                              ],
                            ),
                            onTap: () {
                              //  Implement leaderboard
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(s.coming_soon)),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Recent Activities
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(space),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.recent_activities,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/reward-history'),
                      child: Text(s.view_all),
                    ),
                  ],
                ),
              ),
            ),

            // Recent History List
            if (rewardState.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else if (recentHistory.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(space * 2),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 64,
                          color: theme.disabledColor,
                        ),
                        SizedBox(height: space),
                        Text(
                          s.no_recent_activities,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final history = recentHistory[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: space,
                      vertical: space * 0.5,
                    ),
                    child: _ActivityItem(
                      title: history.itemName,
                      points: history.pointsSpent,
                      date: history.redemptionDate,
                      type: 'Redeemed', // History only shows redeemed items
                    ),
                  );
                }, childCount: recentHistory.length),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(space),
        child: Container(
          padding: EdgeInsets.all(space),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(space),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: theme.scaffoldBackgroundColor),
              SizedBox(height: space * 0.5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.scaffoldBackgroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final int points;
  final DateTime date;
  final String type;

  const _ActivityItem({
    required this.title,
    required this.points,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(space * 0.8),
      ),
      child: Padding(
        padding: EdgeInsets.all(space),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(space * 0.8),
              decoration: BoxDecoration(
                color: type == 'Earned'
                    ? theme.primaryColor.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                type == 'Earned' ? Icons.add_circle : Icons.redeem,
                color: type == 'Earned'
                    ? theme.primaryColor
                    : AppColors.warning,
                size: 24,
              ),
            ),
            SizedBox(width: space),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${type == 'Earned' ? '+' : '-'}$points',
              style: theme.textTheme.titleMedium?.copyWith(
                color: type == 'Earned' ? theme.primaryColor : AppColors.danger,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
