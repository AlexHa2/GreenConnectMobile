import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/payment_method_bottom_sheet.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApproveButton extends ConsumerWidget {
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;
  final bool skipPaymentMethod;

  const ApproveButton({
    super.key,
    required this.transaction,
    required this.onActionCompleted,
    this.skipPaymentMethod = false,
  });

  Future<void> _handleComplete(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;

    // If skipPaymentMethod is true (totalPrice <= 0), call processTransaction directly without payment method
    if (skipPaymentMethod) {
      try {
        // Get required parameters
        final scrapPostId = transaction.offer?.scrapPostId ?? '';
        final collectorId = transaction.scrapCollectorId;
        final slotId = transaction.timeSlotId ?? transaction.offer?.timeSlotId ?? '';
        
        if (scrapPostId.isEmpty || collectorId.isEmpty || slotId.isEmpty) {
          if (context.mounted) {
            CustomToast.show(context, s.operation_failed, type: ToastType.error);
          }
          return;
        }

        // Call API to complete transaction without payment method
        final success = await ref
            .read(transactionViewModelProvider.notifier)
            .processTransaction(
              scrapPostId: scrapPostId,
              collectorId: collectorId,
              slotId: slotId,
              transactionId: transaction.transactionId,
              isAccepted: true,
              // No paymentMethod parameter when totalPrice <= 0
            );

        if (!context.mounted) return;

        if (success) {
          CustomToast.show(
            context,
            s.transaction_approved,
            type: ToastType.success,
          );
          onActionCompleted();
        } else {
          final state = ref.read(transactionViewModelProvider);
          final errorMsg = state.errorMessage;
          
          CustomToast.show(
            context,
            errorMsg ?? s.operation_failed,
            type: ToastType.error,
          );
        }
      } catch (e) {
        if (context.mounted) {
          CustomToast.show(context, s.operation_failed, type: ToastType.error);
        }
      }
      return;
    }

    // Show payment method selection bottom sheet (when totalPrice > 0)
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentMethodBottomSheet(
        transaction: transaction,
        onActionCompleted: onActionCompleted,
      ),
    );

    // If payment was successful, trigger the callback
    if (result == true) {
      onActionCompleted();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final state = ref.watch(transactionViewModelProvider);
    final isProcessing = state.isProcessing;

    return ElevatedButton(
      onPressed: isProcessing ? null : () => _handleComplete(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        disabledBackgroundColor: theme.primaryColor.withValues(alpha: 0.6),
      ),
      child: isProcessing
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.scaffoldBackgroundColor,
                ),
              ),
            )
          : Text(
              s.completed,
              style: TextStyle(
                color: theme.scaffoldBackgroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
