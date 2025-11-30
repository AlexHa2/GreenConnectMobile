import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class TransactionStatusHelper {
  /// Return localized status text
  static String getLocalizedStatus(
    BuildContext context,
    TransactionStatus status,
  ) {
    final s = S.of(context)!;

    switch (status) {
      case TransactionStatus.scheduled:
        return s.transaction_scheduled;

      case TransactionStatus.inProgress:
        return s.transaction_inProgress;

      case TransactionStatus.completed:
        return s.transaction_completed;

      case TransactionStatus.canceledBySystem:
        return s.transaction_canceledBySystem;

      case TransactionStatus.canceledByUser:
        return s.transaction_canceledByUser;
    }
  }

  /// Return localized status using displayKey (short form)
  static String getShortStatus(BuildContext context, TransactionStatus status) {
    final s = S.of(context)!;

    switch (status.displayKey) {
      case 'in_progress':
        return s.transaction_inProgress;
      case 'completed':
        return s.transaction_completed;
      case 'cancelled':
        return s.transaction_cancelled;
      default:
        return s.transaction_inProgress;
    }
  }
}
