import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class TransactionStatusHeader extends StatelessWidget {
  final TransactionEntity transaction;
  final ThemeData theme;
  final double space;
  final S s;

  const TransactionStatusHeader({
    super.key,
    required this.transaction,
    required this.theme,
    required this.space,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: _getStatusColor().withValues(alpha: 0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: space,
              vertical: space / 2,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: BorderRadius.circular(space),
            ),
            child: Text(
              _getStatusText().toUpperCase(),
              style: TextStyle(
                color: theme.scaffoldBackgroundColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                s.scheduled_time,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              SizedBox(height: space / 4),
              Text(
                transaction.scheduledTime != null
                    ? transaction.scheduledTime!.toCustomFormat(locale: s.localeName)
                    : 'Chưa có lịch hẹn',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (transaction.statusEnum) {
      case TransactionStatus.scheduled:
        return AppColors.warningUpdate;
      case TransactionStatus.inProgress:
        return theme.primaryColor;
      case TransactionStatus.completed:
        return AppColors.primary;
      case TransactionStatus.canceledBySystem:
      case TransactionStatus.canceledByUser:
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  String _getStatusText() {
    switch (transaction.statusEnum) {
      case TransactionStatus.scheduled:
        return s.pending;
      case TransactionStatus.inProgress:
        return s.in_progress;
      case TransactionStatus.completed:
        return s.completed;
      case TransactionStatus.canceledBySystem:
      case TransactionStatus.canceledByUser:
        return s.cancelled;
    }
  }
}
