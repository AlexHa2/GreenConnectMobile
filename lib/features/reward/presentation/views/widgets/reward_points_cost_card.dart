import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Points cost card for reward detail
class RewardPointsCostCard extends StatelessWidget {
  final int pointsCost;
  final String pointsLabel;

  const RewardPointsCostCard({
    super.key,
    required this.pointsCost,
    required this.pointsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(space * 1.5),
      decoration: BoxDecoration(
        gradient: AppColors.linearSecondary,
        borderRadius: BorderRadius.circular(space * 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.stars,
            color: AppColors.warningUpdate,
            size: 32,
          ),
          SizedBox(width: space),
          Text(
            '$pointsCost',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark,
            ),
          ),
          SizedBox(width: space * 0.5),
          Text(
            pointsLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }
}
