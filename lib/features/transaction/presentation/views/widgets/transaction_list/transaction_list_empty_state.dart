import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Empty state widget for transaction list
class TransactionListEmptyState extends StatelessWidget {
  const TransactionListEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: space * 8,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: space * 2),
          Text(
            s.no_transactions_found,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading more indicator widget
class TransactionListLoadingIndicator extends StatelessWidget {
  const TransactionListLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;

    return Padding(
      padding: EdgeInsets.all(space * 2),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
