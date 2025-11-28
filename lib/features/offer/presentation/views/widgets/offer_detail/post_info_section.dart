import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class PostInfoSection extends StatelessWidget {
  final ScrapPostEntity post;
  final ThemeData theme;
  final double spacing;
  final S s;

  const PostInfoSection({
    super.key,
    required this.post,
    required this.theme,
    required this.spacing,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Row(
              children: [
                Icon(
                  Icons.article_outlined,
                  color: theme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: spacing / 2),
                Text(
                  s.post_information,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),

          // Content
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                _buildInfoItem(
                  icon: Icons.title_outlined,
                  label: s.post_title,
                  value: post.title,
                ),
                SizedBox(height: spacing * 0.75),

                // Description
                if (post.description.isNotEmpty &&
                    post.description.isNotEmpty) ...[
                  _buildInfoItem(
                    icon: Icons.description_outlined,
                    label: s.post_description,
                    value: post.description,
                  ),
                  SizedBox(height: spacing * 0.75),
                ],

                // Location/Address
                _buildInfoItem(
                  icon: Icons.location_on_outlined,
                  label: s.location,
                  value: post.address,
                ),
                SizedBox(height: spacing * 0.75),

                // Posted date
                if (post.createdAt != null)
                  _buildInfoItem(
                    icon: Icons.calendar_today_outlined,
                    label: s.posted_at,
                    value: TimeAgoHelper.format(context, post.createdAt!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(spacing * 0.75),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(spacing / 2),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.primaryColor),
              SizedBox(width: spacing / 2),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing / 2),
          Padding(
            padding: EdgeInsets.only(left: spacing * 1.5),
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
