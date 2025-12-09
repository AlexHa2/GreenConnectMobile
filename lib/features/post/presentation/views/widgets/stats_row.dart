import 'package:GreenConnectMobile/features/post/domain/entities/household_report_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final bool isLoading;
  final List<PostStatusModel> postModels;

  const StatsRow({super.key, this.isLoading = false, required this.postModels});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final s = S.of(context)!;

    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.screenPadding),
        child: Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < 2 ? spacing.screenPadding : 0,
                ),
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(spacing.screenPadding),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Map post status to display info
    final statusMap = {
      for (var model in postModels) model.postStatus: model.totalPosts,
    };

    final openCount = statusMap['Open'] ?? 0;
    final partiallyBookedCount = statusMap['PartiallyBooked'] ?? 0;
    final fullyBookedCount = statusMap['FullyBooked'] ?? 0;
    final completedCount = statusMap['Completed'] ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.screenPadding),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.article_outlined,
              value: openCount.toString(),
              label: s.open,
              color: AppColors.info,
            ),
          ),
          SizedBox(width: spacing.screenPadding),
          Expanded(
            child: _StatCard(
              icon: Icons.schedule_rounded,
              value: (partiallyBookedCount + fullyBookedCount).toString(),
              label: s.booked,
              color: AppColors.warningUpdate,
            ),
          ),
          SizedBox(width: spacing.screenPadding),
          Expanded(
            child: _StatCard(
              icon: Icons.done_all_rounded,
              value: completedCount.toString(),
              label: s.completed,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Container(
      padding: EdgeInsets.all(spacing.screenPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(spacing.screenPadding),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(spacing.screenPadding),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
