import 'package:GreenConnectMobile/features/reward/presentation/views/widges/achivement_card.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widges/activity_card.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widges/sub_widge.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RewardDashboard extends StatelessWidget {
  const RewardDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    final space = spacing.screenPadding;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(space),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: space),

            Container(
              decoration: BoxDecoration(
                gradient: AppColors.linearPrimary,
                borderRadius: BorderRadius.circular(space * 2),
              ),
              padding: EdgeInsets.symmetric(
                vertical: space * 2,
                horizontal: space * 2,
              ),
              child: Column(
                children: [
                  Text(
                    "${s.reward} ${s.dashboard}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.scaffoldBackgroundColor,
                      fontSize: space * 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: space / 2),
                  Text(
                    s.keep_making_difference,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.scaffoldBackgroundColor,
                    ),
                  ),
                  SizedBox(height: space * 2),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: 0.85,
                          strokeWidth: 10,
                          backgroundColor: theme.scaffoldBackgroundColor,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.warning,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "850",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.scaffoldBackgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            s.points,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.scaffoldBackgroundColor,
                              fontSize: space,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: space * 2),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SubWidge(label: s.this_week, value: "200pts"),
                      SubWidge(label: s.rank, value: "#42h"),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: space * 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.achievement, style: theme.textTheme.titleLarge),
                TextButton(onPressed: () {}, child: Text(s.view_all)),
              ],
            ),
            SizedBox(height: space),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AchievementCard(title: "Green Hero"),
                AchievementCard(title: "Recycler"),
                AchievementCard(title: "Computer"),
                AchievementCard(title: "100 days"),
              ],
            ),

            SizedBox(height: space * 2),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                icon: Icon(
                  Icons.card_giftcard,
                  color: theme.brightness == Brightness.light
                      ? theme.textTheme.bodyMedium?.color
                      : theme.scaffoldBackgroundColor,
                ),
                label: Text(
                  s.redeem_rewards,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.brightness == Brightness.light
                        ? theme.textTheme.bodyMedium?.color
                        : theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: space * 2),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(s.recent_activity, style: theme.textTheme.titleLarge),
            ),
            SizedBox(height: space),
            const ActivityCard(
              title: "Recycled plastic bottles",
              points: "30",
              status: "Completed",
              weight: "20kg",
              value: "30.0",
              date: "2024-06-15",
              description: "Recycled plastic bottles",
            ),
            const ActivityCard(
              title: "Recycled plastic bottles",
              points: "30",
              status: "Completed",
              weight: "20kg",
              value: "30.0",
              date: "2024-06-15",
              description: "Recycled plastic bottles",
            ),
            const ActivityCard(
              title: "Recycled plastic bottles",
              points: "30",
              status: "Completed",
              weight: "20kg",
              value: "30.0",
              date: "2024-06-15",
              description: "Recycled plastic bottles",
            ),

            SizedBox(height: space),
            CustomOutlinedButton(
              text: s.view_all_history,
              onPressed: () {
                context.push('/post-history');
              },
              icon: Icons.history,
            ),
            SizedBox(height: space),
          ],
        ),
      ),
    );
  }
}
