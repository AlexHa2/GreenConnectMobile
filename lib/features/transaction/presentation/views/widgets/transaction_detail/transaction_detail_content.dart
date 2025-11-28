import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_items_section.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_party_info.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Main content body for transaction detail
class TransactionDetailContentBody extends StatelessWidget {
  final TransactionEntity transaction;
  final String userRole;

  const TransactionDetailContentBody({
    super.key,
    required this.transaction,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Column(
      children: [
        TransactionHeaderInfo(transaction: transaction),
        SizedBox(height: spacing * 1.5),
        TransactionSummaryCard(transaction: transaction),
        SizedBox(height: spacing * 1.5),
        TransactionPartyInfo(
          transaction: transaction,
          userRole: userRole,
          theme: theme,
          space: spacing,
          s: s,
        ),
        SizedBox(height: spacing * 1.5),
        if (transaction.transactionDetails.isNotEmpty)
          TransactionItemsSection(
            transactionDetails: transaction.transactionDetails,
            theme: theme,
            space: spacing,
            s: s,
          ),
      ],
    );
  }
}

/// Header info with status and ID
class TransactionHeaderInfo extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionHeaderInfo({
    super.key,
    required this.transaction,
  });

  IconData _getStatusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.scheduled:
        return Icons.schedule;
      case TransactionStatus.inProgress:
        return Icons.loop;
      case TransactionStatus.completed:
        return Icons.check_circle_outline;
      default:
        return Icons.cancel_outlined;
    }
  }

  String _localizeStatus(S s, TransactionStatus status) {
    switch (status) {
      case TransactionStatus.scheduled:
        return s.scheduled;
      case TransactionStatus.inProgress:
        return s.in_progress;
      case TransactionStatus.completed:
        return s.completed;
      default:
        return s.cancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Column(
      children: [
        // Status badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing * 1.5,
            vertical: spacing * 0.5,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(transaction.statusEnum),
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: spacing * 0.5),
              Text(
                _localizeStatus(s, transaction.statusEnum).toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),

        // Transaction ID
        SizedBox(height: spacing * 0.5),
        GestureDetector(
          onTap: () {
            Clipboard.setData(
              ClipboardData(text: transaction.transactionId),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copied ID: ${transaction.transactionId}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Text(
            'ID: ${transaction.transactionId}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}

/// Summary card with key transaction info
class TransactionSummaryCard extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionSummaryCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;
    final locale = s.localeName;

    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(
                label: s.total_amount,
                value: NumberFormat.compactCurrency(
                  locale: locale,
                  symbol: s.per_unit,
                  decimalDigits: 0,
                ).format(transaction.totalPrice),
                color: AppColors.primary,
                icon: Icons.payments_outlined,
              ),
            ),
            VerticalDivider(
              width: spacing * 2,
              thickness: 1,
              color: theme.dividerColor.withValues(alpha: 0.5),
            ),
            Expanded(
              child: _SummaryItem(
                label: s.scheduled_time,
                value: transaction.scheduledTime.toCustomFormat(
                  locale: s.localeName,
                ),
                color: AppColors.warningUpdate,
                icon: Icons.calendar_today_outlined,
              ),
            ),
            VerticalDivider(
              width: spacing * 2,
              thickness: 1,
              color: theme.dividerColor.withValues(alpha: 0.5),
            ),
            Expanded(
              child: _SummaryItem(
                label: "Số lượng",
                value: "${transaction.transactionDetails.length}",
                color: theme.primaryColor,
                icon: Icons.inventory_2_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual summary item
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
