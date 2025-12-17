import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Header for feedback list with sort functionality
class FeedbackListHeader extends StatelessWidget {
  final bool? sortByCreatAt;
  final VoidCallback onToggleSort;

  const FeedbackListHeader({
    super.key,
    required this.sortByCreatAt,
    required this.onToggleSort,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    return Container(
      color: theme.cardColor,
      padding: EdgeInsets.fromLTRB(
        spacing,
        MediaQuery.of(context).padding.top + spacing,
        spacing,
        spacing,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      
                      context.go('/collector-home'); 
                    }
                  },
                  tooltip: s.back,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Text(
                  s.feedback.toUpperCase(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildSortButton(theme, spacing, s),
            ],
          ),
          SizedBox(height: spacing * 0.8),
          _buildSortInfo(theme, spacing, s),
        ],
      ),
    );
  }

  Widget _buildSortButton(ThemeData theme, double spacing, S s) {
    return Material(
      color: theme.primaryColor,
      borderRadius: BorderRadius.circular(spacing),
      child: InkWell(
        onTap: onToggleSort,
        borderRadius: BorderRadius.circular(spacing),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing,
            vertical: spacing * 0.8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                sortByCreatAt == true
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                size: 18,
                color: Colors.white,
              ),
              SizedBox(width: spacing * 0.5),
              Text(
                sortByCreatAt == true ? s.newest_first : s.oldest_first,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortInfo(ThemeData theme, double spacing, S s) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: spacing * 0.8,
        vertical: spacing * 0.6,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(spacing * 0.7),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: theme.primaryColor,
          ),
          SizedBox(width: spacing * 0.5),
          Expanded(
            child: Text(
              sortByCreatAt == true ? s.most_recent_at_top : s.earliest_at_top,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
