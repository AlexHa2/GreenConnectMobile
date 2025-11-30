import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/confirm_dialog_helper.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  bool get _canTakeAction {
    final status = transaction.statusEnum;
    return _isHousehold && status == TransactionStatus.inProgress;
  }

  bool get _isCompleted {
    return transaction.statusEnum == TransactionStatus.completed;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;

    // Show review/complain buttons for completed transactions
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
          child: _CompletedTransactionActions(
            transactionId: transaction.transactionId,
            onActionCompleted: onActionCompleted,
          ),
        ),
      );
    }

    // Show approve/reject buttons for in-progress transactions
    if (!_canTakeAction) {
      return const SizedBox.shrink();
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
        child: Row(
          children: [
            Expanded(
              child: _RejectButton(
                transactionId: transaction.transactionId,
                onActionCompleted: onActionCompleted,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _ApproveButton(
                transactionId: transaction.transactionId,
                onActionCompleted: onActionCompleted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reject/Cancel button
class _RejectButton extends ConsumerWidget {
  final String transactionId;
  final VoidCallback onActionCompleted;

  const _RejectButton({
    required this.transactionId,
    required this.onActionCompleted,
  });

  Future<void> _handleCancel(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;

    // Show confirmation dialog
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.cancel_transaction,
      message: s.cancel_message,
      confirmText: s.cancel_transaction,
      isDestructive: true,
    );

    if (confirmed != true || !context.mounted) return;

    try {
      // Call API to cancel transaction
      await ref
          .read(transactionViewModelProvider.notifier)
          .processTransaction(
        transactionId: transactionId,
        isAccepted: false,
      );

      if (context.mounted) {
        CustomToast.show(
          context,
          s.transaction_cancelled,
          type: ToastType.success,
        );
        onActionCompleted();
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.show(
          context,
          s.operation_failed,
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context)!;

    return ElevatedButton(
      onPressed: () => _handleCancel(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        s.cancel_transaction,
        style: TextStyle(
          color: theme.scaffoldBackgroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Approve/Complete button
class _ApproveButton extends ConsumerWidget {
  final String transactionId;
  final VoidCallback onActionCompleted;

  const _ApproveButton({
    required this.transactionId,
    required this.onActionCompleted,
  });

  Future<void> _handleComplete(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;

    // Show confirmation dialog
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.completed,
      message: s.approve_message,
      confirmText: s.completed,
      isDestructive: false,
    );

    if (confirmed != true || !context.mounted) return;

    try {
      // Call API to complete transaction
      await ref
          .read(transactionViewModelProvider.notifier)
          .processTransaction(
        transactionId: transactionId,
        isAccepted: true,
      );

      if (context.mounted) {
        CustomToast.show(
          context,
          s.transaction_approved,
          type: ToastType.success,
        );
        onActionCompleted();
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.show(
          context,
          s.operation_failed,
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context)!;

    return ElevatedButton(
      onPressed: () => _handleComplete(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        s.completed,
        style: TextStyle(
          color: theme.scaffoldBackgroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Action buttons for completed transactions
class _CompletedTransactionActions extends StatelessWidget {
  final String transactionId;
  final VoidCallback onActionCompleted;

  const _CompletedTransactionActions({
    required this.transactionId,
    required this.onActionCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Row(
      children: [
        // Review button
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await context.pushNamed<bool>(
                'create-feedback',
                extra: {'transactionId': transactionId},
              );
              if (result == true) {
                onActionCompleted();
              }
            },
            icon: Icon(Icons.star, size: spacing * 1.8),
            label: Text(s.write_review),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: theme.scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: spacing),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        // Complain button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              final result = await context.pushNamed<bool>(
                'create-complaint',
                extra: {'transactionId': transactionId},
              );
              if (result == true) {
                onActionCompleted();
              }
            },
            icon: Icon(Icons.report_problem, size: spacing * 1.8),
            label: Text(s.complain),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger, width: 1.5),
              padding: EdgeInsets.symmetric(vertical: spacing),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
