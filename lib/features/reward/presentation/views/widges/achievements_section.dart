import 'package:GreenConnectMobile/features/reward/presentation/views/widges/achivement_card.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class AchievementsSection extends StatelessWidget {
  final String title;
  final String viewAllLabel;
  final VoidCallback onViewAll;

  const AchievementsSection({
    super.key,
    required this.title,
    required this.viewAllLabel,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events_rounded, color: theme.primaryColor),
                SizedBox(width: space / 2),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: onViewAll,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: Text(viewAllLabel),
              style: TextButton.styleFrom(foregroundColor: theme.primaryColor),
            ),
          ],
        ),
        SizedBox(height: space),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AchievementCard(title: "Green Hero"),
              SizedBox(width: 8),
              AchievementCard(title: "Recycler"),
              SizedBox(width: 8),
              AchievementCard(title: "Computer"),
              SizedBox(width: 8),
              AchievementCard(title: "100 days"),
            ],
          ),
        ),
      ],
    );
  }
}
