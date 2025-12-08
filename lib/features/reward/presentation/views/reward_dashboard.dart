import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/achievements_section.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/action_card.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/dashboard_header.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/points_card.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RewardDashboard extends StatelessWidget {
  const RewardDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final s = S.of(context)!;
    final space = spacing.screenPadding;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const DashboardHeader(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(space),
                  child: const PointsCard(points: 850, progress: 0.85),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: space),
                  child: Row(
                    children: [
                      Expanded(
                        child: ActionCard(
                          icon: Icons.card_giftcard_rounded,
                          label: s.redeem_rewards,
                          gradient: AppColors.linearPrimary,
                          onTap: () => context.push('/reward-store'),
                        ),
                      ),
                      SizedBox(width: space),
                      Expanded(
                        child: ActionCard(
                          icon: Icons.history_rounded,
                          label: s.view_all_history,
                          gradient: AppColors.linearPrimary,
                          onTap: () => context.push('/post-history'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: space * 2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: space),
                  child: AchievementsSection(
                    title: s.achievement,
                    viewAllLabel: s.view_all,
                    onViewAll: () {},
                  ),
                ),
                SizedBox(height: space * 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
