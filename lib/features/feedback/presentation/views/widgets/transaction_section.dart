import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Transaction information section in feedback detail
class TransactionSection extends StatelessWidget {
  final String transactionId;

  const TransactionSection({
    super.key,
    required this.transactionId,
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
          Text(
            s.transaction_information,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing),
          _buildTransactionId(theme, spacing, s),
          SizedBox(height: spacing),
          _buildViewButton(context, theme, spacing, s),
        ],
      ),
    );
  }

  Widget _buildTransactionId(ThemeData theme, double spacing, S s) {
    return Row(
      children: [
        Icon(Icons.receipt_long, color: theme.primaryColor, size: 20),
        SizedBox(width: spacing * 0.8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.transaction_id,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                transactionId,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewButton(
    BuildContext context,
    ThemeData theme,
    double spacing,
    S s,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          context.pushNamed(
            'transaction-detail',
            extra: {'transactionId': transactionId},
          );
        },
        icon: const Icon(Icons.visibility),
        label: Text(s.view_transaction),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.primaryColor,
          side: BorderSide(color: theme.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing),
          ),
          padding: EdgeInsets.symmetric(vertical: spacing),
        ),
      ),
    );
  }
}
