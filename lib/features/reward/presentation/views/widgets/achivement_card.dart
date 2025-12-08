import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
  final String title;
  const AchievementCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space),
        gradient: AppColors.linearSecondary,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: space, horizontal: space),
        child: Column(
          children: [
            Icon(Icons.star, color: AppColors.warning, size: space * 3),
            SizedBox(height: space / 2),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
