import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Filter header with title and filter button
class TransactionListHeader extends StatelessWidget {
  final String filterType;
  final bool isDescending;
  final VoidCallback onFilterTap;

  const TransactionListHeader({
    super.key,
    required this.filterType,
    required this.isDescending,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Container(
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
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
              onPressed: () => Navigator.of(context).pop(),
              tooltip: s.back,
            ),
          ),
          SizedBox(width: space),
          Expanded(
            child: Text(
              s.my_transactions,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _FilterButton(
            filterType: filterType,
            isDescending: isDescending,
            onTap: onFilterTap,
          ),
        ],
      ),
    );
  }
}

/// Filter button widget
class _FilterButton extends StatelessWidget {
  final String filterType;
  final bool isDescending;
  final VoidCallback onTap;

  const _FilterButton({
    required this.filterType,
    required this.isDescending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(space * 2),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: space * 1.2,
          vertical: space * 0.8,
        ),
        decoration: BoxDecoration(
          color: theme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(space * 2),
          border: Border.all(
            color: theme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDescending ? Icons.arrow_downward : Icons.arrow_upward,
              size: space * 1.5,
              color: theme.primaryColor,
            ),
            SizedBox(width: space * 0.5),
            Text(
              filterType == 'updateAt'
                  ? s.transaction_updated_time
                  : s.transaction_created_time,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: space * 0.3),
            Icon(
              Icons.tune,
              size: space * 1.3,
              color: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
