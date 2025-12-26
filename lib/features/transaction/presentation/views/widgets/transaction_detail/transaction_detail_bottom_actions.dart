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
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom action buttons for transaction detail
class TransactionDetailBottomActions extends ConsumerWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final double amountDifference; // Amount difference từ post transactions
  final VoidCallback onActionCompleted;
  final post_entity.PostTransactionsResponseEntity? transactionsData;

  const TransactionDetailBottomActions({
    super.key,
    required this.transaction,
    required this.userRole,
    this.amountDifference = 0.0, // Default 0 nếu không có
    required this.onActionCompleted,
    this.transactionsData,
  });

  bool get _isHousehold => userRole == Role.household;

  bool get _isCollector =>
      userRole == Role.individualCollector ||
      userRole == Role.businessCollector;

  bool get _canTakeAction {
    if (!_isHousehold ||
        transaction.statusEnum != TransactionStatus.inProgress) {
      return false;
    }

    // Validate that scrapPostId, collectorId, and slotId are available
    final scrapPostId = transaction.offer?.scrapPostId ?? '';
    final collectorId = transaction.scrapCollectorId;
    final slotId =
        transaction.timeSlotId ?? transaction.offer?.timeSlotId ?? '';

    return scrapPostId.isNotEmpty &&
        collectorId.isNotEmpty &&
        slotId.isNotEmpty;
  }

  /// Check if household should show approve button without payment method
  /// Sử dụng amountDifference nếu có, fallback về totalPrice
  bool get _shouldApproveWithoutPayment {
    if (!_canTakeAction) return false;

    // Ưu tiên sử dụng amountDifference nếu đã load được
    // Nếu amountDifference == 0 (default) và totalPrice > 0, có thể chưa load xong
    // Nên fallback về totalPrice để đảm bảo logic đúng
    final effectiveAmount =
        amountDifference != 0.0 ? amountDifference : transaction.totalPrice;

    return effectiveAmount == 0;
  }

  /// Check if household should show approve button with payment method
  /// Sử dụng amountDifference nếu có, fallback về totalPrice
  bool get _shouldApproveWithPayment {
    if (!_canTakeAction) return false;

    // Ưu tiên sử dụng amountDifference nếu đã load được
    final effectiveAmount =
        amountDifference != 0.0 ? amountDifference : transaction.totalPrice;

    return effectiveAmount != 0;
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
          spacing / 12,
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
          spacing / 12,
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
          ),
        ),
      );
    }

    // Show input details and toggle cancel buttons for collector when InProgress
    if (_canInputDetails || _canToggleCancel) {
      final buttons = <Widget>[];

      // Priority 1: Input details button (for entering actual scrap quantity)
      // Always show when collector can input details, regardless of totalPrice
      if (_canInputDetails) {
        buttons.add(
          Expanded(
            flex: 2,
            child: InputDetailsButton(
              transaction: transaction,
              onActionCompleted: onActionCompleted,
              transactionsData: transactionsData,
            ),
          ),
        );
      }

      // Priority 3: Toggle cancel button (emergency cancel/resume)
      if (_canToggleCancel) {
        if (buttons.isNotEmpty) {
          buttons.add(SizedBox(width: spacing * 0.75));
        }
        buttons.add(
          Expanded(
            child: ToggleCancelButton(
              transaction: transaction,
              onActionCompleted: onActionCompleted,
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.fromLTRB(
          spacing,
          spacing / 12,
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
      // When totalPrice > 0: Show both reject and approve buttons (with payment method selection)
      return Container(
        padding: EdgeInsets.fromLTRB(
          spacing,
          spacing / 12,
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
                child: RejectButton(
                  transaction: transaction,
                  onActionCompleted: onActionCompleted,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: ApproveButton(
                  transaction: transaction,
                  onActionCompleted: onActionCompleted,
                  skipPaymentMethod: false,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // When totalPrice <= 0: Show only approve button (without payment method)
    if (_shouldApproveWithoutPayment) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          spacing,
          spacing / 12,
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
          child: ApproveButton(
            transaction: transaction,
            onActionCompleted: onActionCompleted,
            skipPaymentMethod: true,
          ),
        ),
      );
    }

    // No action buttons to show
    return const SizedBox.shrink();
  }
}
