import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/check_in_location_dialog.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckInButton extends ConsumerWidget {
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;

  const CheckInButton({
    super.key,
    required this.transaction,
    required this.onActionCompleted,
  });

  Future<void> _handleCheckIn(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;

    // Show check-in dialog with GPS location
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) =>
          CheckInLocationDialog(transactionId: transaction.transactionId),
    );

    if (result == null || !context.mounted) return;

    final latitude = result['latitude'] as double?;
    final longitude = result['longitude'] as double?;

    if (latitude == null || longitude == null) {
      if (context.mounted) {
        CustomToast.show(
          context,
          s.location_fetch_error,
          type: ToastType.error,
        );
      }
      return;
    }

    try {
      final success = await ref
          .read(transactionViewModelProvider.notifier)
          .checkInTransaction(
            transactionId: transaction.transactionId,
            latitude: latitude,
            longitude: longitude,
          );

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.check_in_success,
            type: ToastType.success,
          );
          // Delay callback to ensure Navigator is not locked after pop
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              onActionCompleted();
            }
          });
        } else {
          final state = ref.read(transactionViewModelProvider);
          final errorMsg = state.errorMessage;

          if (errorMsg != null &&
              (errorMsg.contains('khoảng cách') ||
                  errorMsg.contains('distance') ||
                  errorMsg.contains('quá xa'))) {
            CustomToast.show(
              context,
              s.distance_too_far_error,
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
        onPressed: isProcessing ? null : () => _handleCheckIn(context, ref),
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
            : const Icon(Icons.location_on, size: 20),
        label: Text(
          s.check_in,
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
