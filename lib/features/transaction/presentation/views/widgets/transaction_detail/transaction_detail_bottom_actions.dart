import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/approve_button.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/check_in_button.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/completed_transaction_actions.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/input_details_button.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/reject_button.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/toggle_cancel_button.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom action buttons for transaction detail
class TransactionDetailBottomActions extends ConsumerWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final VoidCallback onActionCompleted;

  const TransactionDetailBottomActions({
    super.key,
    required this.transaction,
    required this.userRole,
    required this.onActionCompleted,
  });

  bool get _isHousehold => userRole == Role.household;

  bool get _isCollector =>
      userRole == Role.individualCollector ||
      userRole == Role.businessCollector;

  bool get _canTakeAction {
    final status = transaction.statusEnum;
    return _isHousehold && status == TransactionStatus.inProgress;
  }

  bool get _isCompleted {
    return transaction.statusEnum == TransactionStatus.completed;
  }

  bool get _canToggleCancel {
    return _isCollector &&
        (transaction.statusEnum == TransactionStatus.inProgress ||
            transaction.statusEnum == TransactionStatus.canceledByUser);
  }

  bool get _canCheckIn {
    return _isCollector &&
        transaction.statusEnum == TransactionStatus.scheduled &&
        transaction.checkInTime == null;
  }

  bool get _canInputDetails {
    return _isCollector &&
        transaction.statusEnum == TransactionStatus.inProgress;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;

    // Show review/complain buttons for completed transactions
    // Review button: household only, Complaint button: all roles
    if (_isCompleted) {
      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: CompletedTransactionActions(
            transactionId: transaction.transactionId,
            onActionCompleted: onActionCompleted,
            userRole: userRole,
          ),
        ),
      );
    }

    // Show check-in button for collector when Scheduled
    if (_canCheckIn) {
      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: CheckInButton(
            transaction: transaction,
            onActionCompleted: onActionCompleted,
          ),
        ),
      );
    }

    // Show input details and toggle cancel buttons for collector when InProgress
    if (_canInputDetails || _canToggleCancel) {
      final buttons = <Widget>[];

      // Priority: Input details button (for entering actual scrap quantity)
      if (_canInputDetails) {
        buttons.add(
          Expanded(
            flex: 2,
            child: InputDetailsButton(
              transaction: transaction,
              onActionCompleted: onActionCompleted,
            ),
          ),
        );
      }

      // Toggle cancel button (emergency cancel/resume)
      if (_canToggleCancel) {
        if (buttons.isNotEmpty) {
          buttons.add(SizedBox(width: spacing));
        }
        buttons.add(
          Expanded(
            child: ToggleCancelButton(
              transaction: transaction,
              onActionCompleted: onActionCompleted,
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: buttons.length == 1 ? buttons.first : Row(children: buttons),
        ),
      );
    }

    // Show approve/reject buttons for in-progress transactions (household)
    if (_canTakeAction) {
      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: RejectButton(
                  transactionId: transaction.transactionId,
                  onActionCompleted: onActionCompleted,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: ApproveButton(
                  transactionId: transaction.transactionId,
                  onActionCompleted: onActionCompleted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // No action buttons to show
    return const SizedBox.shrink();
  }
}
