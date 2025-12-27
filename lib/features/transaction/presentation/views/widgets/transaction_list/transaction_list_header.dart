import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

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
          // Back button - fixed size
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
              padding: EdgeInsets.all(space * 0.5),
              constraints: const BoxConstraints(),
            ),
          ),
          SizedBox(width: space),
          // Title - flexible, responsive
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                s.my_transactions,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: space * 0.5),
          // Filter button - responsive
          Flexible(
            child: _FilterButton(
              filterType: filterType,
              isDescending: isDescending,
              onTap: onFilterTap,
              isSmallScreen: isSmallScreen,
            ),
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
  final bool isSmallScreen;

  const _FilterButton({
    required this.filterType,
    required this.isDescending,
    required this.onTap,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    // Responsive sizing
    final iconSize = isSmallScreen ? space * 1.2 : space * 1.5;
    final fontSize = isSmallScreen ? 12.0 : null;
    final horizontalPadding = isSmallScreen ? space * 0.8 : space * 1.2;
    final verticalPadding = isSmallScreen ? space * 0.6 : space * 0.8;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(space * 2),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
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
              size: iconSize,
              color: theme.primaryColor,
            ),
            SizedBox(width: space * 0.5),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  filterType == 'updateAt'
                      ? s.transaction_updated_time
                      : s.transaction_created_time,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: space * 0.3),
            Icon(
              Icons.tune,
              size: iconSize * 0.87, // Slightly smaller than arrow icon
              color: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
