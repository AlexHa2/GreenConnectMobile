import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackEntity feedback;
  final VoidCallback? onTap;

  const FeedbackCard({super.key, required this.feedback, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(spacing),
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Reviewer & Rating
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                    backgroundImage: feedback.reviewer.avatarUrl != null
                        ? NetworkImage(feedback.reviewer.avatarUrl!)
                        : null,
                    child: feedback.reviewer.avatarUrl == null
                        ? Icon(
                            Icons.person,
                            color: theme.primaryColor,
                            size: 28,
                          )
                        : null,
                  ),
                  SizedBox(width: spacing),

                  // Reviewer info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feedback.reviewer.fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: spacing / 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.warning,
                              size: 16,
                            ),
                            SizedBox(width: spacing / 3),
                            Text(
                              '${feedback.rate}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning,
                              ),
                            ),
                            SizedBox(width: spacing / 3),
                            Text(
                              '⭐',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Time
                  Text(
                    TimeAgoHelper.format(context, feedback.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing),

              // Comment
              if (feedback.comment.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacing * 0.8),
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(spacing * 0.7),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    feedback.comment,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: spacing * 0.8),
              ],

              // Footer: Reviewee & Transaction
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        SizedBox(width: spacing / 3),
                        Flexible(
                          child: Text(
                            '${s.for_transaction}: ${feedback.reviewee.fullName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: spacing * 0.5),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing * 0.6,
                      vertical: spacing * 0.3,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(spacing * 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 12,
                          color: theme.primaryColor,
                        ),
                        SizedBox(width: spacing / 3),
                        Text(
                          s.transaction,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
