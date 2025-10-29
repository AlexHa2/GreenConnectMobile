import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class JobItemCard extends StatelessWidget {
  final String title;
  final String address;
  final String distance;
  final int points;
  final String category;
  final Color categoryColor;
  final VoidCallback onTap;

  const JobItemCard({
    super.key,
    required this.title,
    required this.address,
    required this.distance,
    required this.points,
    required this.category,
    required this.categoryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(spacing.screenPadding * 1.5),
      child: Container(
        padding: EdgeInsets.all(spacing.screenPadding * 1.5),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(spacing.screenPadding * 1.5),
          border: Border.all(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: spacing.screenPadding),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.screenPadding,
                    vertical: spacing.screenPadding / 3,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(
                      spacing.screenPadding / 2,
                    ),
                  ),
                  child: Text(
                    category,
                    style: textTheme.bodySmall?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing.screenPadding),

            // Address
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: theme.textTheme.bodyMedium?.color,
                ),
                SizedBox(width: spacing.screenPadding / 2),
                Expanded(
                  child: Text(
                    address,
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing.screenPadding * 1.5),

            // Divider
            Container(
              height: 1,
              color: theme.dividerColor,
            ),

            SizedBox(height: spacing.screenPadding * 1.2),

            // Distance and Points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  distance,
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: spacing.screenPadding / 3),
                    Text(
                      '$points pts',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

