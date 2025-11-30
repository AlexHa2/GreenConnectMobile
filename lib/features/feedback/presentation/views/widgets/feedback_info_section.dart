import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class FeedbackInfoSection extends StatelessWidget {
  final int rating;
  final String comment;
  final DateTime createdAt;

  const FeedbackInfoSection({
    super.key,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;
    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            s.feedback_information,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing),

          // Rating
          _buildInfoRow(
            context,
            icon: Icons.star,
            iconColor: AppColors.warning,
            label: s.given_rating,
            valueWidget: buildStarRating(rating.toDouble()),
            theme: theme,
            spacing: spacing,
          ),

          SizedBox(height: spacing * 0.8),

          // Date
          _buildInfoRow(
            context,
            icon: Icons.calendar_today,
            iconColor: theme.primaryColor,
            label: s.feedback_date,
            valueWidget: Text(
              createdAt.toCustomFormat(locale: s.localeName),
              style: theme.textTheme.bodyMedium,
            ),
            theme: theme,
            spacing: spacing,
          ),

          if (comment.isNotEmpty) ...[
            SizedBox(height: spacing),
            Divider(color: theme.dividerColor),
            SizedBox(height: spacing * 0.8),

            // Comment
            Text(
              s.comment,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(height: spacing * 0.6),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(spacing),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(spacing * 0.7),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(comment, style: theme.textTheme.bodyMedium),
            ),
          ],

          if (comment.isEmpty) ...[
            SizedBox(height: spacing),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(spacing),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(spacing * 0.7),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  SizedBox(width: spacing * 0.5),
                  Text(
                    'No comment provided',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required Widget valueWidget,
    required ThemeData theme,
    required double spacing,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(spacing * 0.5),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(spacing * 0.5),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 2),
              valueWidget,
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStarRating(double rating, {double size = 18}) {
    List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(Icon(Icons.star, size: size, color: AppColors.warning));
      } else if (rating >= i - 0.5) {
        stars.add(Icon(Icons.star_half, size: size, color: AppColors.warning));
      } else {
        stars.add(
          Icon(Icons.star_border, size: size, color: AppColors.warning),
        );
      }
    }

    return Row(children: stars);
  }
}
