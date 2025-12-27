import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart'
    as post_entity;
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/approve_button.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/check_in_button.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/completed_transaction_actions.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/input_details_button.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/reject_button.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/transaction_detail/actions/toggle_cancel_button.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Bottom action buttons for transaction detail
class TransactionDetailBottomActions extends ConsumerWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final double amountDifference; // Amount difference from post transactions
  final VoidCallback onActionCompleted;
  final post_entity.PostTransactionsResponseEntity? transactionsData;
  final VoidCallback? onCheckInSuccess; // Callback when checkin is successful
  final VoidCallback? onApproveSuccess; // Callback when approve is successful to navigate to transaction list
  final VoidCallback? onRejectSuccess; // Callback when reject is successful to navigate to transaction list
  final VoidCallback? onInputDetailsSuccess; // Callback when input details is successful to navigate to transaction list

  const TransactionDetailBottomActions({
    super.key,
    required this.transaction,
    required this.userRole,
    this.amountDifference = 0.0,
    required this.onActionCompleted,
    this.transactionsData,
    this.onCheckInSuccess,
    this.onApproveSuccess,
    this.onRejectSuccess,
    this.onInputDetailsSuccess,
  });

  bool get _isHousehold => userRole == Role.household;

  bool get _isCollector =>
      userRole == Role.individualCollector ||
      userRole == Role.businessCollector;

  bool get _canTakeAction {
    final isHousehold = _isHousehold;
    final status = transaction.statusEnum;
    final isInProgress = status == TransactionStatus.inProgress;
    
    if (!isHousehold || !isInProgress) {
      return false;
    }

    // Validate that scrapPostId, collectorId, and slotId are available
    final scrapPostId = transaction.offer?.scrapPostId ?? '';
    final collectorId = transaction.scrapCollectorId;
    final slotId =
        transaction.timeSlotId ?? transaction.offer?.timeSlotId ?? '';

    final result = scrapPostId.isNotEmpty &&
        collectorId.isNotEmpty &&
        slotId.isNotEmpty;
    
    return result;
  }

  /// Check if household should show approve button without payment method
  /// When amountDifference <= 0, no payment method is needed
  bool get _shouldApproveWithoutPayment {
    if (!_canTakeAction) return false;

    // When amountDifference <= 0, no payment is needed
    // amountDifference == 0: no payment needed
    // amountDifference < 0: household will receive money (collector pays), no payment method needed
    // Don't check _hasQuantityEntered here - if amountDifference <= 0, no payment is needed
    return amountDifference <= 0.0;
  }

  /// Check if household should show approve button with payment method
  /// When amountDifference > 0, always require payment method selection
  bool get _shouldApproveWithPayment {
    final canTakeAction = _canTakeAction;
    final result = canTakeAction && amountDifference > 0.0;

    
    return result;
  }

  /// Check if collector should show payment method button
  /// only check amountDifference AFTER collector has entered quantity successfully
  /// When amountDifference < 0: Collector needs to pay household
  bool get _shouldCollectorShowPayment {
    if (!_isCollector ||
        transaction.statusEnum != TransactionStatus.inProgress) {
      return false;
    }

    // only check amountDifference when collector has entered quantity
    if (!_hasQuantityEntered) return false;

    // Validate that scrapPostId and slotId are available
    final scrapPostId = transaction.offer?.scrapPostId ?? '';
    final slotId =
        transaction.timeSlotId ?? transaction.offer?.timeSlotId ?? '';

    if (scrapPostId.isEmpty || slotId.isEmpty) {
      return false;
    }

    // amountDifference < 0: Collector needs to pay household
    return amountDifference < 0.0;
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
    if (!_isCollector ||
        transaction.statusEnum != TransactionStatus.inProgress) {
      return false;
    }

    // Validate that scrapPostId and slotId are available
    final scrapPostId = transaction.offer?.scrapPostId ?? '';
    final slotId =
        transaction.timeSlotId ?? transaction.offer?.timeSlotId ?? '';

    return scrapPostId.isNotEmpty && slotId.isNotEmpty;
  }

  /// Check if collector has entered quantity for transaction
  /// Transaction has quantity when transactionDetails has at least one item with quantity > 0
  bool get _hasQuantityEntered {
    if (transaction.transactionDetails.isEmpty) {
      return false;
    }
    // Check if any transaction detail has quantity > 0
    return transaction.transactionDetails.any((detail) => detail.quantity > 0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;

    // Show review/complain buttons for completed transactions
    // Review button: household only, Complaint button: all roles
    if (_isCompleted) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          spacing,
          spacing * 1.5, // Increased top padding for better spacing
          spacing,
          spacing / 12,
        ),
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
          top: false,
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
        padding: EdgeInsets.fromLTRB(
          spacing,
          spacing * 1.5, // Increased top padding for better spacing
          spacing,
          spacing / 12,
        ),
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
            onCheckInSuccess: onCheckInSuccess,
          ),
        ),
      );
    }

    // Show QR payment button for collector when amountDifference < 0
    // Navigate QR code payment page
    if (_shouldCollectorShowPayment) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          spacing,
          spacing * 1.5, // Increased top padding for better spacing
          spacing,
          spacing / 12,
        ),
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
          child: Builder(
            builder: (context) {
              return FilledButton.icon(
                onPressed: () async {
                  // Navigate directly to QR code payment page
                  // showActionButtons = false:
                  final result = await context.push(
                    '/qr-payment',
                    extra: {
                      'transactionId': transaction.transactionId,
                      'transaction': transaction,
                      'onActionCompleted': onActionCompleted,
                      'showActionButtons': false, 
                      'userRole': userRole,
                      'amountDifference': amountDifference,
                    },
                  );

                  if (result == true && context.mounted) {
                    onActionCompleted();
                  }
                },
                icon: const Icon(Icons.qr_code, size: 20),
                label: Text(
                  S.of(context)!.request_payment,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.scaffoldBackgroundColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing * 1.5,
                    vertical: spacing * 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(spacing),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    // Show input details and toggle cancel buttons for collector when InProgress
    if (_canInputDetails || _canToggleCancel) {
      final buttons = <Widget>[];

      // Priority 3: Toggle cancel button (emergency cancel/resume) - danger color, left side
      if (_canToggleCancel) {
        buttons.add(
          Expanded(
            flex: 1,
            child: ToggleCancelButton(
              transaction: transaction,
              onActionCompleted: onActionCompleted,
            ),
          ),
        );
      }

      // Priority 1: Input details button (for entering actual scrap quantity) - primary color, right side
      // Always show when collector can input details, regardless of totalPrice
      if (_canInputDetails) {
        if (buttons.isNotEmpty) {
          buttons.add(SizedBox(width: spacing));
        }
        buttons.add(
          Expanded(
            flex: 2,
            child: InputDetailsButton(
              transaction: transaction,
              onActionCompleted: onActionCompleted,
              transactionsData: transactionsData,
              onInputDetailsSuccess: onInputDetailsSuccess, // Navigate to transaction list after successful input
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.fromLTRB(
          spacing,
          spacing * 1.5, // Increased top padding for better spacing
          spacing,
          spacing / 12,
        ),
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
          top: false,
          child: buttons.length == 1 ? buttons.first : Row(children: buttons),
        ),
      );
    }

    // Show approve/reject buttons for in-progress transactions (household)
    if (_shouldApproveWithPayment) {
      // When amountDifference > 0: Show both reject and approve buttons (with payment method selection)
      return Container(
        padding: EdgeInsets.fromLTRB(
          spacing,
          spacing * 1.5, // Increased top padding for better spacing
          spacing,
          spacing / 12,
        ),
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
                flex: 1,
                child: RejectButton(
                  transaction: transaction,
                  onActionCompleted: onActionCompleted,
                  onRejectSuccess: onRejectSuccess, // Navigate to transaction list after successful reject
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                flex: 2,
                child: ApproveButton(
                  transaction: transaction,
                  onActionCompleted: onActionCompleted,
                  skipPaymentMethod: false,
                  onApproveSuccess: onApproveSuccess,
                  amountDifference: amountDifference,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // When amountDifference <= 0: Show both reject and approve buttons (approve without payment method)
    // This includes amountDifference == 0 (no payment) and amountDifference < 0 (household receives money)
    if (_shouldApproveWithoutPayment) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          spacing,
          spacing * 1.5, // Increased top padding for better spacing
          spacing,
          spacing / 12,
        ),
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
                flex: 1,
                child: RejectButton(
                  transaction: transaction,
                  onActionCompleted: onActionCompleted,
                  onRejectSuccess: onRejectSuccess, // Navigate to transaction list after successful reject
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                flex: 2,
                child: ApproveButton(
                  transaction: transaction,
                  onActionCompleted: onActionCompleted,
                  skipPaymentMethod: true,
                  onApproveSuccess: onApproveSuccess,
                  amountDifference: amountDifference,
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
