import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/payment_method_bottom_sheet.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApproveButton extends ConsumerWidget {
  final String transactionId;
  final VoidCallback onActionCompleted;

  const ApproveButton({
    super.key,
    required this.transactionId,
    required this.onActionCompleted,
  });

  Future<void> _handleComplete(BuildContext context, WidgetRef ref) async {
    // Show payment method selection bottom sheet
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentMethodBottomSheet(
        transactionId: transactionId,
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
