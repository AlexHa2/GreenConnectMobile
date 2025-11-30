import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final UserEntity user;
  final String title;
  final bool isReviewer;

  const UserInfoSection({
    super.key,
    required this.user,
    required this.title,
    this.isReviewer = false,
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
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing),

          // User card
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 32,
                backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: theme.primaryColor,
                        size: 32,
                      )
                    : null,
              ),
              SizedBox(width: spacing),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    _buildInfoChip(
                      context,
                      icon: Icons.phone,
                      label: user.phoneNumber,
                      theme: theme,
                      spacing: spacing,
                    ),
                    SizedBox(height: 4),
                    _buildInfoChip(
                      context,
                      icon: Icons.military_tech,
                      label: user.rank,
                      theme: theme,
                      spacing: spacing,
                      color: _getRankColor(user.rank),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: spacing),
          Divider(color: theme.dividerColor),
          SizedBox(height: spacing * 0.8),

          // Additional info
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.stars,
                  label: s.points,
                  value: user.pointBalance.toString(),
                  theme: theme,
                  spacing: spacing,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.verified_user,
                  label: s.rank,
                  value: user.rank,
                  theme: theme,
                  spacing: spacing,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ThemeData theme,
    required double spacing,
    Color? color,
  }) {
    final chipColor = color ?? theme.textTheme.bodySmall?.color ?? Colors.grey;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: chipColor,
        ),
        SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: chipColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    required double spacing,
  }) {
    return Container(
      padding: EdgeInsets.all(spacing * 0.8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(spacing * 0.7),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: theme.primaryColor,
          ),
          SizedBox(height: spacing * 0.3),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(String rank) {
    switch (rank.toLowerCase()) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'platinum':
        return const Color(0xFFE5E4E2);
      case 'diamond':
        return const Color(0xFFB9F2FF);
      default:
        return Colors.grey;
    }
  }
}
