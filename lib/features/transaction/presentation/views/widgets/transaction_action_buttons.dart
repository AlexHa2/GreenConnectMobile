import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/confirm_dialog_helper.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/dialogs/check_in_dialog.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/dialogs/feedback_dialog_transaction.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/dialogs/input_details_dialog.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widgets/dialogs/process_transaction_dialog.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionActionButtons extends ConsumerWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final ThemeData theme;
  final double space;
  final S s;
  final VoidCallback onActionCompleted;

  const TransactionActionButtons({
    super.key,
    required this.transaction,
    required this.userRole,
    required this.theme,
    required this.space,
    required this.s,
    required this.onActionCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildActionButtons(context, ref),
        ),
      ),
    );
  }

  bool _canCheckIn() {
    return transaction.statusEnum.canCheckIn && transaction.checkInTime == null;
  }

  bool _canInputDetails() {
    return transaction.statusEnum.canInputDetails &&
        transaction.checkInTime != null;
  }

  bool _canProcess() {
    return transaction.statusEnum.canInputDetails;
  }

  bool _canCancel() {
    return transaction.statusEnum.canCancel;
  }

  bool _canProvideFeedback() {
    return transaction.statusEnum.isCompleted;
  }

  bool _canToggleCancel() {
    return userRole != Role.household &&
        (transaction.statusEnum == TransactionStatus.inProgress ||
            transaction.statusEnum == TransactionStatus.canceledByUser);
  }

  List<Widget> _buildActionButtons(BuildContext context, WidgetRef ref) {
    final buttons = <Widget>[];

    // Collector actions
    if (userRole == Role.individualCollector ||
        userRole == Role.businessCollector) {
      if (_canCheckIn()) {
        buttons.add(_buildCheckInButton(context));
      } else if (_canInputDetails()) {
        buttons.add(_buildInputDetailsButton(context));
      } else if (_canCancel()) {
        buttons.add(_buildCancelButton(context, ref));
      }

      // Toggle cancel button for emergency situations
      if (_canToggleCancel()) {
        if (buttons.isNotEmpty) {
          buttons.add(SizedBox(height: space));
        }
        buttons.add(_buildToggleCancelButton(context, ref));
      }
    }

    // Household actions
    if (userRole == Role.household) {
      if (_canProcess()) {
        buttons.addAll([
          Row(
            children: [
              Expanded(child: _buildRejectButton(context)),
              SizedBox(width: space),
              Expanded(flex: 2, child: _buildApproveButton(context)),
            ],
          ),
        ]);
      } else if (_canCancel()) {
        buttons.add(_buildCancelButton(context, ref));
      }
      // Note: Toggle cancel API is only for collector, not household
    }

    // Feedback button (all roles after completion)
    if (_canProvideFeedback()) {
      if (buttons.isNotEmpty) {
        buttons.add(SizedBox(height: space));
      }
      buttons.add(_buildFeedbackButton(context));
    }

    return buttons;
  }

  Widget _buildCheckInButton(BuildContext context) {
    return GradientButton(
      onPressed: () => _showCheckInDialog(context),
      text: s.check_in,
      icon:  Icon(Icons.location_on, color: theme.scaffoldBackgroundColor),
    );
  }

  Widget _buildInputDetailsButton(BuildContext context) {
    return GradientButton(
      onPressed: () => _showInputDetailsDialog(context),
      text: s.input_details,
      icon: Icon(Icons.edit, color: theme.scaffoldBackgroundColor),
    );
  }

  Widget _buildApproveButton(BuildContext context) {
    return GradientButton(
      onPressed: () => _showProcessDialog(context, isApprove: true),
      text: s.approve,
      icon:  Icon(Icons.check, color:theme.scaffoldBackgroundColor),
    );
  }

  Widget _buildRejectButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _showProcessDialog(context, isApprove: false),
      icon: const Icon(Icons.close),
      label: Text(s.reject),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: space),
        side: const BorderSide(color: AppColors.danger, width: 2),
        foregroundColor: AppColors.danger,
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () => _showCancelDialog(context, ref),
      icon: const Icon(Icons.cancel_outlined),
      label: Text(s.cancel_transaction),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: space),
        side: const BorderSide(color: AppColors.warningUpdate, width: 2),
        foregroundColor: AppColors.warningUpdate,
      ),
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _showFeedbackDialog(context),
      icon: const Icon(Icons.rate_review_outlined),
      label: Text(s.provide_feedback),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: space),
        side: BorderSide(color: theme.primaryColor, width: 2),
        foregroundColor: theme.primaryColor,
      ),
    );
  }

  Widget _buildToggleCancelButton(BuildContext context, WidgetRef ref) {
    final isCanceled =
        transaction.statusEnum == TransactionStatus.canceledByUser;
    return OutlinedButton.icon(
      onPressed: () => _showToggleCancelDialog(context, ref),
      icon: Icon(isCanceled ? Icons.restart_alt : Icons.warning_amber_rounded),
      label: Text(
        isCanceled ? s.resume_transaction : s.emergency_cancel,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: space),
        side: BorderSide(
          color: isCanceled ? AppColors.warningUpdate : AppColors.danger,
          width: 2,
        ),
        foregroundColor: isCanceled
            ? AppColors.warningUpdate
            : AppColors.danger,
        backgroundColor: isCanceled
            ? AppColors.warningUpdate.withValues(alpha: 0.05)
            : AppColors.danger.withValues(alpha: 0.05),
      ),
    );
  }

  void _showCheckInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CheckInDialog(
        transactionId: transaction.transactionId,
        onSuccess: () {
          Navigator.pop(context);
          _showSuccessSnackBar(context, s.check_in_success);
          onActionCompleted();
        },
      ),
    );
  }

  void _showInputDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => InputDetailsDialog(
        transactionId: transaction.transactionId,
        onSuccess: () {
          Navigator.pop(context);
          _showSuccessSnackBar(context, s.details_saved);
          onActionCompleted();
        },
      ),
    );
  }

  void _showProcessDialog(BuildContext context, {required bool isApprove}) {
    showDialog(
      context: context,
      builder: (context) => ProcessTransactionDialog(
        transactionId: transaction.transactionId,
        isApprove: isApprove,
        onSuccess: () {
          Navigator.pop(context);
          _showSuccessSnackBar(
            context,
            isApprove ? s.transaction_approved : s.transaction_rejected,
          );
          onActionCompleted();
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.cancel_confirm,
      message: s.cancel_message,
      confirmText: s.cancel,
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      try {
        final success = await ref
            .read(transactionViewModelProvider.notifier)
            .toggleCancelTransaction(transaction.transactionId);

        if (context.mounted) {
          if (success) {
            _showSuccessSnackBar(context, s.transaction_cancelled);
            onActionCompleted();
          } else {
            // Check for specific error message from state
            final state = ref.read(transactionViewModelProvider);
            final errorMsg = state.errorMessage;

            if (errorMsg != null &&
                (errorMsg.contains('progress') ||
                    errorMsg.contains(
                      'Trạng thái giao dịch không phải là progress',
                    ))) {
              _showErrorSnackBar(
                context,
                'Transaction must be in InProgress status to cancel.',
              );
            } else {
              _showErrorSnackBar(context, s.operation_failed);
            }
          }
        }
      } catch (e) {
        if (context.mounted) {
          if (e is AppException) {
            if (e.statusCode == 400 &&
                (e.message?.contains('progress') == true ||
                    e.message?.contains(
                          'Trạng thái giao dịch không phải là progress',
                        ) ==
                        true)) {
              _showErrorSnackBar(
                context,
                'Transaction must be in InProgress status to cancel.',
              );
            } else {
              _showErrorSnackBar(context, e.message ?? s.operation_failed);
            }
          } else {
            _showErrorSnackBar(context, s.operation_failed);
          }
        }
      }
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FeedbackDialogTransaction(
        transactionId: transaction.transactionId,
        onSuccess: () {
          Navigator.pop(context);
          _showSuccessSnackBar(context, s.feedback_submitted);
          onActionCompleted();
        },
      ),
    );
  }

  void _showToggleCancelDialog(BuildContext context, WidgetRef ref) async {
    final isCanceled =
        transaction.statusEnum == TransactionStatus.canceledByUser;

    // Show custom dialog with warning note for emergency cancel
    if (!isCanceled) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(space),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
              SizedBox(width: space),
              Expanded(
                child: Text(
                  s.emergency_cancel_confirm,
                  style: const TextStyle(
                    color: AppColors.danger,
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
              Text(s.emergency_cancel_message),
              SizedBox(height: space),
              Container(
                padding: EdgeInsets.all(space),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(space),
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
                      size: space * 1.5,
                    ),
                    SizedBox(width: space),
                    Expanded(
                      child: Text(
                        s.emergency_cancel_note,
                        style:const TextStyle(
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.back),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: theme.scaffoldBackgroundColor,
              ),
              child: Text(s.emergency_cancel),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;
    } else {
      // Use ConfirmDialogHelper for resume
      final confirmed = await ConfirmDialogHelper.show(
        context: context,
        title: s.resume_confirm,
        message: s.resume_message,
        confirmText: s.resume,
        isDestructive: false,
      );

      if (confirmed != true || !context.mounted) return;
    }

    // Execute toggle cancel
    try {
      final success = await ref
          .read(transactionViewModelProvider.notifier)
          .toggleCancelTransaction(transaction.transactionId);

      if (context.mounted) {
        if (success) {
          _showSuccessSnackBar(
            context,
            isCanceled
                ? s.transaction_resumed
                : s.transaction_emergency_canceled,
          );
          onActionCompleted();
        } else {
          // Check for specific error message from state
          final state = ref.read(transactionViewModelProvider);
          final errorMsg = state.errorMessage;

          if (errorMsg != null &&
              (errorMsg.contains('progress') ||
                  errorMsg.contains(
                    'Trạng thái giao dịch không phải là progress',
                  ))) {
            _showErrorSnackBar(
              context,
              'Transaction must be in InProgress status to perform this action.',
            );
          } else {
            _showErrorSnackBar(context, s.operation_failed);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        if (e is AppException) {
          if (e.statusCode == 400 &&
              (e.message?.contains('progress') == true ||
                  e.message?.contains(
                        'Trạng thái giao dịch không phải là progress',
                      ) ==
                      true)) {
            _showErrorSnackBar(
              context,
              'Transaction must be in InProgress status to perform this action.',
            );
          } else {
            _showErrorSnackBar(context, e.message ?? s.operation_failed);
          }
        } else {
          _showErrorSnackBar(context, s.operation_failed);
        }
      }
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
             Icon(Icons.check_circle, color: theme.scaffoldBackgroundColor),
            SizedBox(width: space),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: theme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: theme.scaffoldBackgroundColor),
            SizedBox(width: space),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
