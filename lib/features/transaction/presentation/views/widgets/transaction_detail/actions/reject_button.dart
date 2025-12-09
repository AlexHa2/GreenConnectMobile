import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/confirm_dialog_helper.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RejectButton extends ConsumerWidget {
  final String transactionId;
  final VoidCallback onActionCompleted;

  const RejectButton({
    super.key,
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
          .processTransaction(transactionId: transactionId, isAccepted: false);

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

    return ElevatedButton(
      onPressed: isProcessing ? null : () => _handleCancel(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        disabledBackgroundColor: AppColors.danger.withValues(alpha: 0.6),
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
              s.cancel_transaction,
              style: TextStyle(
                color: theme.scaffoldBackgroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
