import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/input_scrap_quantity_dialog.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputDetailsButton extends ConsumerWidget {
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;

  const InputDetailsButton({
    super.key,
    required this.transaction,
    required this.onActionCompleted,
  });

  Future<void> _handleInputDetails(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;

    // Show input details dialog
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

      final success = await ref
          .read(transactionViewModelProvider.notifier)
          .updateTransactionDetails(
            transactionId: transaction.transactionId,
            details: details,
          );

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.quantity_updated_successfully,
            type: ToastType.success,
          );
          onActionCompleted();
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

    return ElevatedButton.icon(
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
          : const Icon(Icons.edit),
      label: Text(
        s.enter_quantity,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        disabledBackgroundColor: theme.primaryColor.withValues(alpha: 0.6),
      ),
    );
  }
}
