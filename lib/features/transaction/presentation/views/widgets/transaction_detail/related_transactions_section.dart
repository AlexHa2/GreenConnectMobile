import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/helper/currency_helper.dart';
import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart'
    as post_entity;
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Section to display related transactions from fetchPostTransactions response
class RelatedTransactionsSection extends StatelessWidget {
  final post_entity.PostTransactionsResponseEntity? transactionsData;
  final bool isLoadingTransactions;
  final String currentTransactionId;

  const RelatedTransactionsSection({
    super.key,
    this.transactionsData,
    this.isLoadingTransactions = false,
    required this.currentTransactionId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    // Show loading state
    if (isLoadingTransactions) {
      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(spacing * 1.5),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.swap_horiz_rounded,
                  color: theme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: spacing * 0.5),
                Text(
                  s.related_transactions,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    // Don't show if no data
    if (transactionsData == null || transactionsData!.transactions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Filter out current transaction and get related ones
    final relatedTransactions = transactionsData!.transactions
        .where((t) => t.transactionId != currentTransactionId)
        .toList();

    // Don't show if no related transactions
    if (relatedTransactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing * 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing * 0.6),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(spacing * 0.8),
                ),
                child: Icon(
                  Icons.swap_horiz_rounded,
                  color: theme.primaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: spacing * 0.5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.related_transactions,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (transactionsData!.amountDifference != 0)
                      Text(
                        s.amount_difference(
                            formatVND(transactionsData!.amountDifference)),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: transactionsData!.amountDifference > 0
                              ? theme.primaryColor
                              : AppColors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: spacing * 1.2),

          // Transactions list
          ...relatedTransactions.map((transaction) {
            return Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: _RelatedTransactionCard(
                transaction: transaction,
                isCurrent: transaction.transactionId == currentTransactionId,
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Card for individual related transaction
class _RelatedTransactionCard extends StatelessWidget {
  final post_entity.TransactionEntity transaction;
  final bool isCurrent;

  const _RelatedTransactionCard({
    required this.transaction,
    this.isCurrent = false,
  });

  TransactionStatus _getStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return TransactionStatus.scheduled;
      case 'in_progress':
      case 'inprogress':
        return TransactionStatus.inProgress;
      case 'completed':
        return TransactionStatus.completed;
      case 'canceled_by_user':
      case 'canceledbyuser':
        return TransactionStatus.canceledByUser;
      case 'canceled_by_system':
      case 'canceledbysystem':
        return TransactionStatus.canceledBySystem;
      default:
        return TransactionStatus.scheduled;
    }
  }

  Color _getStatusColor(TransactionStatus status, BuildContext context) {
    final theme = Theme.of(context);
    switch (status) {
      case TransactionStatus.scheduled:
        return theme.colorScheme.onSurface;
      case TransactionStatus.inProgress:
        return AppColors.warningUpdate;
      case TransactionStatus.completed:
        return theme.primaryColor;
      case TransactionStatus.canceledBySystem:
      case TransactionStatus.canceledByUser:
        return AppColors.danger;
    }
  }

  String _getStatusLabel(TransactionStatus status, S s) {
    switch (status) {
      case TransactionStatus.scheduled:
        return s.scheduled;
      case TransactionStatus.inProgress:
        return s.in_progress;
      case TransactionStatus.completed:
        return s.completed;
      case TransactionStatus.canceledBySystem:
      case TransactionStatus.canceledByUser:
        return s.cancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;
    final status = _getStatusFromString(transaction.status);
    final statusColor = _getStatusColor(status, context);

    return InkWell(
      onTap: () {
        // Navigate to transaction detail
        final postId = transaction.offer?.scrapPostId;
        final collectorId = transaction.scrapCollectorId;
        final slotId = transaction.timeSlotId ?? transaction.offer?.timeSlotId;

        context.pushNamed(
          'transaction-detail',
          extra: {
            'transactionId': transaction.transactionId,
            if (postId != null && postId.isNotEmpty) 'postId': postId,
            if (collectorId.isNotEmpty) 'collectorId': collectorId,
            if (slotId != null && slotId.isNotEmpty) 'slotId': slotId,
            'hasTransactionData': true,
            'transactionStatus': transaction.status,
            'transactionTotalPrice': transaction.totalPrice,
            'transactionCreatedAt': transaction.createdAt.toIso8601String(),
            'transactionScheduledTime':
                transaction.scheduledTime?.toIso8601String(),
            'transactionCheckInTime':
                transaction.checkInTime?.toIso8601String(),
            'transactionUpdatedAt': transaction.updatedAt?.toIso8601String(),
            'householdId': transaction.householdId,
            'householdName': transaction.household?.fullName ?? '',
            'householdPhone': transaction.household?.phoneNumber ?? '',
            'householdPointBalance': transaction.household?.pointBalance ?? 0,
            'householdRank': transaction.household?.rank ?? '',
            'householdRoles': transaction.household?.roles ?? [],
            'scrapCollectorId': transaction.scrapCollectorId,
            'collectorName': transaction.scrapCollector?.fullName ?? '',
            'collectorPhone': transaction.scrapCollector?.phoneNumber ?? '',
            'collectorPointBalance':
                transaction.scrapCollector?.pointBalance ?? 0,
            'collectorRank': transaction.scrapCollector?.rank ?? '',
            'collectorRoles': transaction.scrapCollector?.roles ?? [],
            'offerId': transaction.offerId,
            'timeSlotId': transaction.timeSlotId,
          },
        );
      },
      borderRadius: BorderRadius.circular(spacing),
      child: Container(
        padding: EdgeInsets.all(spacing * 1.2),
        decoration: BoxDecoration(
          color: isCurrent
              ? theme.primaryColor.withValues(alpha: 0.05)
              : theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(spacing),
          border: Border.all(
            color: isCurrent
                ? theme.primaryColor.withValues(alpha: 0.3)
                : theme.dividerColor,
            width: isCurrent ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Status and ID
            Row(
              children: [
                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing * 0.8,
                    vertical: spacing * 0.3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: spacing * 0.4),
                      Text(
                        _getStatusLabel(status, s),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Transaction ID
                Text(
                  '${s.id_label} '
                  '${transaction.transactionId.length > 8 ? '${transaction.transactionId.substring(0, 8)}...' : transaction.transactionId}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing * 0.8),

            // Info row: Date and Price
            Row(
              children: [
                // Date
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: theme.hintColor,
                      ),
                      SizedBox(width: spacing * 0.4),
                      Flexible(
                        child: Text(
                          transaction.createdAt
                              .toCustomFormat(locale: s.localeName),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Price
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing * 0.8,
                    vertical: spacing * 0.4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    formatVND(transaction.totalPrice),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            // Transaction details count
            if (transaction.transactionDetails.isNotEmpty) ...[
              SizedBox(height: spacing * 0.6),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 14,
                    color: theme.hintColor,
                  ),
                  SizedBox(width: spacing * 0.4),
                  Text(
                    '${transaction.transactionDetails.length} ${s.items}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
