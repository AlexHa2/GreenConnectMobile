import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final String acceptedCount;
  final String completedCount;
  final String availableCount;
  const StatsRow({
    super.key,
    required this.acceptedCount,
    required this.completedCount,
    required this.availableCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final s = S.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.screenPadding),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.check_circle_outline_rounded,
              value: acceptedCount,
              label: s.accepted,
              color: theme.primaryColor,
            ),
          ),
          SizedBox(width: spacing.screenPadding),
          Expanded(
            child: _StatCard(
              icon: Icons.done_all_rounded,
              value: completedCount,
              label: s.completed,
              color: AppColors.info,
            ),
          ),
          SizedBox(width: spacing.screenPadding),
          Expanded(
            child: _StatCard(
              icon: Icons.inventory_2_outlined,
              value: availableCount,
              label: s.available,
              color: AppColors.warningUpdate,
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
