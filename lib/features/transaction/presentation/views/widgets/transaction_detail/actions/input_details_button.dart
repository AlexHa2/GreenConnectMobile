import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart'
    as post_entity;
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/input_all_transactions_quantity_dialog.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/input_scrap_quantity_dialog.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputDetailsButton extends ConsumerWidget {
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;
  final post_entity.PostTransactionsResponseEntity? transactionsData;

  const InputDetailsButton({
    super.key,
    required this.transaction,
    required this.onActionCompleted,
    this.transactionsData,
  });

  Future<void> _handleInputDetails(BuildContext context, WidgetRef ref) async {
    // If we have transactionsData with multiple transactions, show dialog for all
    if (transactionsData != null && transactionsData!.transactions.length > 1) {
      await _handleInputAllTransactions(context, ref);
    } else {
      // Single transaction - use original dialog
      await _handleInputSingleTransaction(context, ref);
    }
  }

  Future<void> _handleInputAllTransactions(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final s = S.of(context)!;

    // Show bottom sheet for all transactions
    final result = await showModalBottomSheet<List<Map<String, dynamic>>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: InputAllTransactionsQuantityDialog(
            transactionsData: transactionsData!,
          ),
        );
      },
    );

    if (result == null || result.isEmpty || !context.mounted) return;

    try {
      // Convert to TransactionDetailRequest list
      final details = result.map((item) {
        return TransactionDetailRequest(
          scrapCategoryId: item['scrapCategoryId'] as String,
          pricePerUnit: item['pricePerUnit'] as double,
          unit: item['unit'] as String,
          quantity: item['quantity'] as double,
        );
      }).toList();

      // Get scrapPostId and slotId from transaction
      // Note: API endpoint is shared for all transactions in the same scrapPost and slot
      final scrapPostId = transaction.offer?.scrapPostId ?? '';
      final slotId =
          transaction.timeSlotId ?? transaction.offer?.timeSlotId ?? '';

      if (scrapPostId.isEmpty || slotId.isEmpty) {
        if (context.mounted) {
          CustomToast.show(
            context,
            s.operation_failed,
            type: ToastType.error,
          );
        }
        return;
      }

      // API endpoint /v1/transactions/details?scrapPostId=...&slotId=...
      // is a shared endpoint for ALL transactions in the same scrapPost and slot
      // So we need to send ALL items in ONE request, not split by transaction
      // Use the first transaction's ID for refresh (or we can refresh all transactions after)
      final firstTransactionId =
          transactionsData!.transactions.first.transactionId;

      final success = await ref
          .read(transactionViewModelProvider.notifier)
          .updateTransactionDetails(
            scrapPostId: scrapPostId,
            slotId: slotId,
            transactionId: firstTransactionId,
            details: details, // Send ALL items in one request
          );

      if (!context.mounted) return;

      if (success) {
        CustomToast.show(
          context,
          s.quantity_updated_successfully,
          type: ToastType.success,
        );

        // Notify parent to refresh detail page (don't return to list)
        onActionCompleted();
        // Close the bottom sheet/dialog
        Navigator.of(context).pop();
      } else {
        final state = ref.read(transactionViewModelProvider);
        final errorMsg = state.errorMessage;

        if (errorMsg != null &&
            (errorMsg.contains('Check-in') ||
                errorMsg.contains('check-in') ||
                errorMsg.contains('chưa Check-in'))) {
          CustomToast.show(
            context,
            s.check_in_first_error,
            type: ToastType.error,
          );
        } else if (errorMsg != null &&
            (errorMsg.contains('loại ve chai') ||
                errorMsg.contains('scrap category'))) {
          CustomToast.show(
            context,
            s.invalid_scrap_category_error,
            type: ToastType.error,
          );
        } else {
          CustomToast.show(
            context,
            s.operation_failed,
            type: ToastType.error,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.show(context, s.operation_failed, type: ToastType.error);
      }
    }
  }

  Future<void> _handleInputSingleTransaction(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final s = S.of(context)!;

    // Show input details dialog for single transaction
    final result = await showDialog<List<Map<String, dynamic>>?>(
      context: context,
      builder: (context) => InputScrapQuantityDialog(transaction: transaction),
    );

    if (result == null || result.isEmpty || !context.mounted) return;

    try {
      // Convert to TransactionDetailRequest list
      final details = result.map((item) {
        return TransactionDetailRequest(
          scrapCategoryId: item['scrapCategoryId'] as String,
          pricePerUnit: item['pricePerUnit'] as double,
          unit: item['unit'] as String,
          quantity: item['quantity'] as double,
        );
      }).toList();

      // Get scrapPostId and slotId from transaction
      final scrapPostId = transaction.offer?.scrapPostId ?? '';
      final slotId =
          transaction.timeSlotId ?? transaction.offer?.timeSlotId ?? '';

      if (scrapPostId.isEmpty || slotId.isEmpty) {
        if (context.mounted) {
          CustomToast.show(
            context,
            s.operation_failed,
            type: ToastType.error,
          );
        }
        return;
      }

      final success = await ref
          .read(transactionViewModelProvider.notifier)
          .updateTransactionDetails(
            scrapPostId: scrapPostId,
            slotId: slotId,
            transactionId: transaction.transactionId,
            details: details,
          );

      if (!context.mounted) return;

      if (success) {
        // Show success toast first
        CustomToast.show(
          context,
          s.quantity_updated_successfully,
          type: ToastType.success,
        );

        // Notify parent to refresh detail page (don't return to list)
        onActionCompleted();
        // Close the dialog
        Navigator.of(context).pop();
      } else {
        final state = ref.read(transactionViewModelProvider);
        final errorMsg = state.errorMessage;

        if (errorMsg != null &&
            (errorMsg.contains('Check-in') ||
                errorMsg.contains('check-in') ||
                errorMsg.contains('chưa Check-in'))) {
          CustomToast.show(
            context,
            s.check_in_first_error,
            type: ToastType.error,
          );
        } else if (errorMsg != null &&
            (errorMsg.contains('loại ve chai') ||
                errorMsg.contains('scrap category'))) {
          CustomToast.show(
            context,
            s.invalid_scrap_category_error,
            type: ToastType.error,
          );
        } else {
          CustomToast.show(
            context,
            s.operation_failed,
            type: ToastType.error,
          );
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
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final state = ref.watch(transactionViewModelProvider);
    final isProcessing = state.isProcessing;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: isProcessing ? null : () => _handleInputDetails(context, ref),
        icon: isProcessing
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
            : const Icon(Icons.edit, size: 20),
        label: Text(
          s.enter_quantity,
          style: TextStyle(
            color: theme.scaffoldBackgroundColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
