import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Button for collector to request payment (show QR code) when totalPrice <= 0
class RequestPaymentButton extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;

  const RequestPaymentButton({
    super.key,
    required this.transaction,
    required this.onActionCompleted,
  });

  Future<void> _handleRequestPayment(BuildContext context) async {
    // Navigate to QR code screen (same as Bank Transfer flow)
    final result = await context.push(
      '/qr-payment',
      extra: {
        'transactionId': transaction.transactionId,
        'transaction': transaction,
        'onActionCompleted': onActionCompleted,
      },
    );

    if (result == true && context.mounted) {
      onActionCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context)!;

    return ElevatedButton.icon(
      onPressed: () => _handleRequestPayment(context),
      icon: const Icon(Icons.qr_code),
      label: Text(
        s.request_payment,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

