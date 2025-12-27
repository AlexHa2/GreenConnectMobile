import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleCancelButton extends ConsumerWidget {
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;

  const ToggleCancelButton({
    super.key,
    required this.transaction,
    required this.onActionCompleted,
  });

  Future<void> _handleToggleCancel(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;

    final isCanceled =
        transaction.statusEnum == TransactionStatus.canceledByUser;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing),
        ),
        title: Row(
          children: [
            Icon(
              isCanceled ? Icons.restart_alt : Icons.warning_amber_rounded,
              color: isCanceled ? AppColors.warningUpdate : AppColors.danger,
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Text(
                isCanceled ? s.resume_transaction : s.emergency_cancel,
                style: TextStyle(
                  color:
                      isCanceled ? AppColors.warningUpdate : AppColors.danger,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isCanceled ? s.resume_message : s.emergency_cancel_message),
            if (!isCanceled) ...[
              SizedBox(height: spacing),
              Container(
                padding: EdgeInsets.all(spacing),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(spacing / 2),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.danger,
                      size: spacing * 1.5,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Text(
                        s.emergency_cancel_note,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.danger,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isCanceled ? AppColors.warningUpdate : AppColors.danger,
              foregroundColor: theme.scaffoldBackgroundColor,
            ),
            child: Text(isCanceled ? s.resume : s.emergency_cancel),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final success = await ref
          .read(transactionViewModelProvider.notifier)
          .toggleCancelTransaction(transaction.transactionId);

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            isCanceled
                ? s.transaction_resumed
                : s.transaction_emergency_canceled,
            type: ToastType.success,
          );
          onActionCompleted();
        } else {
          CustomToast.show(context, s.operation_failed, type: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.show(context, s.operation_failed, type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final isCanceled =
        transaction.statusEnum == TransactionStatus.canceledByUser;
    final state = ref.watch(transactionViewModelProvider);
    final isProcessing = state.isProcessing;
    final buttonColor = isCanceled ? AppColors.warningUpdate : AppColors.danger;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: OutlinedButton.icon(
        onPressed:
            isProcessing ? null : () => _handleToggleCancel(context, ref),
        icon: isProcessing
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                ),
              )
            : Icon(
                isCanceled ? Icons.restart_alt : Icons.warning_amber_rounded,
                size: 20,
              ),
        label: Text(
          isCanceled ? s.resume_transaction : s.emergency_cancel,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(
            color: buttonColor,
            width: 2,
          ),
          foregroundColor: buttonColor,
          backgroundColor: buttonColor.withValues(alpha: 0.05),
          disabledForegroundColor: buttonColor,
          disabledBackgroundColor: buttonColor.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
