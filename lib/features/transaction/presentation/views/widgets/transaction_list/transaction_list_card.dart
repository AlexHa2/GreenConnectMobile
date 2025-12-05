import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Transaction card for list view
class TransactionListCard extends StatelessWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final VoidCallback onTap;
  final VoidCallback? onReviewTap;
  final VoidCallback? onComplainTap;

  const TransactionListCard({
    super.key,
    required this.transaction,
    required this.userRole,
    required this.onTap,
    this.onReviewTap,
    this.onComplainTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(space),
      child: Container(
        padding: EdgeInsets.all(space * 1.5),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(space),
          border: Border.all(color: theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _TransactionCardHeader(transaction: transaction, s: s),

            SizedBox(height: space),
            Divider(height: 1, color: theme.dividerColor),
            SizedBox(height: space),

            // Info section
            _TransactionCardInfo(
              transaction: transaction,
              userRole: userRole,
              s: s,
            ),

            // Price chip
            if (transaction.totalPrice > 0) ...[
              SizedBox(height: space),
              _TransactionPriceChip(price: transaction.totalPrice),
            ],

            // Action buttons for completed transactions (only for household)
            if (transaction.statusEnum == TransactionStatus.completed && 
                userRole == Role.household) ...[
              SizedBox(height: space * 1.2),
              _TransactionActionButtons(
                onReviewTap: onReviewTap,
                onComplainTap: onComplainTap,
                s: s,
              ),
            ],

            SizedBox(height: space),

            // View details hint
            _ViewDetailsHint(s: s),
          ],
        ),
      ),
    );
  }
}

/// Card header with ID and status
class _TransactionCardHeader extends StatelessWidget {
  final TransactionEntity transaction;
  final S s;

  const _TransactionCardHeader({required this.transaction, required this.s});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${s.transaction_id}: ${transaction.transactionId}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _TransactionStatusChip(status: transaction.statusEnum, s: s),
      ],
    );
  }
}

/// Status chip widget
class _TransactionStatusChip extends StatelessWidget {
  final TransactionStatus status;
  final S s;

  const _TransactionStatusChip({required this.status, required this.s});

  Color _getStatusColor(BuildContext context) {
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
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  String _getStatusText() {
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
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final statusColor = _getStatusColor(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: space, vertical: space * 0.5),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(space * 2),
      ),
      child: Text(
        _getStatusText(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: space * 0.9,
        ),
      ),
    );
  }
}

/// Card info section
class _TransactionCardInfo extends StatelessWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final S s;

  const _TransactionCardInfo({
    required this.transaction,
    required this.userRole,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;

    return Column(
      children: [
        // Address
        if (transaction.offer?.scrapPost?.address != null) ...[
          _InfoRow(
            icon: Icons.location_on_outlined,
            text: transaction.offer!.scrapPost!.address,
          ),
          SizedBox(height: space * 0.75),
        ],

        // Person/Household name based on role
        if (userRole == Role.household) ...[
          _InfoRow(
            icon: Icons.person_outline,
            text: transaction.scrapCollector.fullName,
          ),
          SizedBox(height: space * 0.75),
        ],

        if (userRole != Role.household) ...[
          _InfoRow(
            icon: Icons.home_outlined,
            text: transaction.household.fullName,
          ),
          SizedBox(height: space * 0.75),
        ],

        // Scheduled time
        if (transaction.scheduledTime != null)
          _InfoRow(
            icon: Icons.schedule_outlined,
            text: transaction.scheduledTime!.toCustomFormat(locale: s.localeName),
          ),
      ],
    );
  }
}

/// Info row widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;

    return Row(
      children: [
        Icon(icon, size: space * 1.5, color: AppColors.textSecondary),
        SizedBox(width: space * 0.75),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Price chip widget
class _TransactionPriceChip extends StatelessWidget {
  final double price;

  const _TransactionPriceChip({required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: space, vertical: space * 0.75),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(space * 0.75),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.attach_money, size: space * 1.5, color: AppColors.primary),
          SizedBox(width: space * 0.5),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action buttons for completed transactions
class _TransactionActionButtons extends StatelessWidget {
  final VoidCallback? onReviewTap;
  final VoidCallback? onComplainTap;
  final S s;

  const _TransactionActionButtons({
    required this.onReviewTap,
    required this.onComplainTap,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;

    return Container(
      padding: EdgeInsets.all(space * 0.8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(space),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Review button
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onReviewTap,
                borderRadius: BorderRadius.circular(space * 0.8),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: space * 0.9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.warning.withValues(alpha: 0.15),
                        AppColors.warning.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(space * 0.8),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: space * 1.6,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: space * 0.5),
                      Text(
                        s.review,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: space * 0.8),
          // Complain button
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onComplainTap,
                borderRadius: BorderRadius.circular(space * 0.8),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: space * 0.9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.danger.withValues(alpha: 0.12),
                        AppColors.danger.withValues(alpha: 0.06),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(space * 0.8),
                    border: Border.all(
                      color: AppColors.danger.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: space * 1.6,
                        color: AppColors.danger,
                      ),
                      SizedBox(width: space * 0.5),
                      Text(
                        s.complain,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// View details hint widget
class _ViewDetailsHint extends StatelessWidget {
  final S s;

  const _ViewDetailsHint({required this.s});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          s.view_details,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: space * 0.5),
        Icon(
          Icons.arrow_forward_ios,
          size: space * 1.2,
          color: theme.primaryColor,
        ),
      ],
    );
  }
}
