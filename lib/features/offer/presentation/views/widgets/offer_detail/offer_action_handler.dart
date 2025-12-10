import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/confirm_dialog_helper.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/create_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/domain/entities/update_schedule_request.dart';
import 'package:GreenConnectMobile/features/schedule/presentation/providers/schedule_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfferActionHandler {
  final BuildContext context;
  final WidgetRef ref;
  final String offerId;
  final VoidCallback? onActionCompleted;

  OfferActionHandler({
    required this.context,
    required this.ref,
    required this.offerId,
    this.onActionCompleted,
  });

  Future<void> handleAcceptOffer() async {
    debugPrint('[OfferActionHandler] handleAcceptOffer called');
    final s = S.of(context)!;

    // Get current offer data to check for pending schedules
    final offerState = ref.read(offerViewModelProvider);
    final offer = offerState.detailData;
    final hasPendingSchedules =
        offer?.scheduleProposals.any(
          (schedule) => schedule.status == ScheduleProposalStatus.pending,
        ) ??
        false;

    // Show only one confirmation dialog (no input)
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.confirm_accept,
      message: hasPendingSchedules
          ? "${s.accept_offer_message}\n\nViệc chấp nhận sẽ tự động chấp nhận tất cả lịch hẹn đang chờ."
          : s.accept_offer_message,
      confirmText: s.accept_offer,
      isDestructive: false,
    );

    if (confirmed == true && context.mounted) {
      // Chỉ gọi processOffer, không gọi processSchedule cho các schedule
      debugPrint(
        '[OfferActionHandler] Calling processOffer for offerId: $offerId',
      );
      final success = await ref
          .read(offerViewModelProvider.notifier)
          .processOffer(offerId: offerId, isAccepted: true);

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.offer_accepted_success,
            type: ToastType.success,
          );
          await _refreshOfferDetail();
          onActionCompleted?.call();
        } else {
          _showErrorToast(s);
        }
      }
    }
  }

  Future<void> handleRejectOffer() async {
    final s = S.of(context)!;

    // Get current offer data to check for pending schedules
    final offerState = ref.read(offerViewModelProvider);
    final offer = offerState.detailData;
    final hasPendingSchedules =
        offer?.scheduleProposals.any(
          (schedule) => schedule.status == ScheduleProposalStatus.pending,
        ) ??
        false;

    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.confirm_reject,
      message: hasPendingSchedules
          ? "${s.reject_offer_message}\n\nViệc từ chối sẽ tự động từ chối tất cả lịch hẹn đang chờ."
          : s.reject_offer_message,
      confirmText: s.reject_offer,
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(offerViewModelProvider.notifier)
          .processOffer(offerId: offerId, isAccepted: false);

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.offer_rejected_success,
            type: ToastType.success,
          );
          await _refreshOfferDetail();
          onActionCompleted?.call();
        } else {
          _showErrorToast(s);
        }
      }
    }
  }

  Future<void> handleCancelOffer() async {
    final s = S.of(context)!;
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.confirm_cancel,
      message: s.cancel_offer_message,
      confirmText: s.cancel_offer,
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(offerViewModelProvider.notifier)
          .toggleCancelOffer(offerId);

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.offer_canceled_success,
            type: ToastType.success,
          );
          await _refreshOfferDetail();
          onActionCompleted?.call();
        } else {
          _showErrorToast(s);
        }
      }
    }
  }

  Future<void> handleRestoreOffer() async {
    final s = S.of(context)!;
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.restore_offer,
      message: s.restore_offer_message,
      confirmText: s.restore_offer,
      isDestructive: false,
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(offerViewModelProvider.notifier)
          .toggleCancelOffer(offerId);

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.offer_restored_success,
            type: ToastType.success,
          );
          await _refreshOfferDetail();
          onActionCompleted?.call();
        } else {
          _showErrorToast(s);
        }
      }
    }
  }

  Future<void> handleProcessSchedule({
    required String scheduleId,
    required bool isAccepted,
  }) async {
    final s = S.of(context)!;
    debugPrint(
      '[OfferActionHandler] handleProcessSchedule called with isAccepted: true for scheduleId: $scheduleId',
    );
    if (isAccepted) {
      // final confirmed = await ConfirmDialogHelper.show(
      //   context: context,
      //   title: s.scheduleConfirmAccept,
      //   message: s.scheduleAcceptMessage,
      //   confirmText: s.scheduleAcceptButton,
      //   isDestructive: false,
      // );
      // if (confirmed == true && context.mounted) {
      //   final success = await ref
      //       .read(scheduleViewModelProvider.notifier)
      //       .processSchedule(
      //         scheduleId: scheduleId,
      //         isAccepted: true,
      //         responseMessage: null,
      //       );
      //   if (context.mounted) {
      //     if (success) {
      //       CustomToast.show(
      //         context,
      //         s.scheduleAcceptSuccess,
      //         type: ToastType.success,
      //       );
      //       await _refreshOfferDetail();
      //       onActionCompleted?.call();
      //     } else {
      //       CustomToast.show(
      //         context,
      //         ref.read(scheduleViewModelProvider).errorMessage ??
      //             s.action_failed,
      //         type: ToastType.error,
      //       );
      //     }
      //   }
      // }
    } else {
      debugPrint(
        '[OfferActionHandler] handleProcessSchedule called with isAccepted: true for scheduleId: $scheduleId',
      );
      // Reject: hiện popup có input lý do, bắt buộc nhập
      final TextEditingController messageController = TextEditingController();
      bool confirmed = false;
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              s.scheduleConfirmReject,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.scheduleRejectMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  s.response_message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: s.response_message_hint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  confirmed = false;
                  Navigator.pop(dialogContext);
                },
                child: Text(s.cancel),
              ),
              ElevatedButton(
                onPressed: messageController.text.trim().isEmpty
                    ? null
                    : () {
                        confirmed = true;
                        Navigator.pop(dialogContext);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(s.scheduleRejectButton),
              ),
            ],
          ),
        ),
      );
      if (confirmed && context.mounted) {
        final success = await ref
            .read(scheduleViewModelProvider.notifier)
            .processSchedule(
              scheduleId: scheduleId,
              isAccepted: false,
              responseMessage: messageController.text.trim(),
            );
        if (context.mounted) {
          if (success) {
            CustomToast.show(
              context,
              s.scheduleRejectSuccess,
              type: ToastType.success,
            );
            await _refreshOfferDetail();
            onActionCompleted?.call();
          } else {
            CustomToast.show(
              context,
              ref.read(scheduleViewModelProvider).errorMessage ??
                  s.action_failed,
              type: ToastType.error,
            );
          }
        }
      }
    }
  }

  Future<void> handleReschedule({
    required DateTime proposedTime,
    required String responseMessage,
  }) async {
    final s = S.of(context)!;

    try {
      final success = await ref
          .read(scheduleViewModelProvider.notifier)
          .createSchedule(
            offerId: offerId,
            request: CreateScheduleRequest(
              proposedTime: proposedTime.toUtc().toIso8601String(),
              responseMessage: responseMessage,
            ),
          );

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.scheduleRescheduleSuccess,
            type: ToastType.success,
          );
          await _refreshOfferDetail();
          onActionCompleted?.call();
        } else {
          final errorMessage =
              ref.read(scheduleViewModelProvider).errorMessage ?? '';
          // Check if it's a 409 conflict error
          String displayMessage = errorMessage;
          if (errorMessage.contains('DATABASE_CONFLICT') ||
              errorMessage.contains('database error') ||
              errorMessage.contains('duplicate')) {
            displayMessage = s.scheduleConflictError;
          } else if (errorMessage.isNotEmpty) {
            displayMessage = errorMessage;
          } else {
            displayMessage = s.action_failed;
          }

          CustomToast.show(context, displayMessage, type: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        String errorMsg = s.action_failed;
        if (e.toString().contains('DATABASE_CONFLICT') ||
            e.toString().contains('409')) {
          errorMsg = s.scheduleConflictError;
        }
        CustomToast.show(context, errorMsg, type: ToastType.error);
      }
    }
  }

  Future<void> handleUpdateSchedule({
    required String scheduleId,
    required DateTime proposedTime,
    required String responseMessage,
  }) async {
    final s = S.of(context)!;

    try {
      final success = await ref
          .read(scheduleViewModelProvider.notifier)
          .updateSchedule(
            scheduleId: scheduleId,
            request: UpdateScheduleRequest(
              proposedTime: proposedTime,
              responseMessage: responseMessage,
            ),
          );

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.scheduleUpdateSuccess,
            type: ToastType.success,
          );
          await _refreshOfferDetail();
          onActionCompleted?.call();
        } else {
          final errorMessage =
              ref.read(scheduleViewModelProvider).errorMessage ?? '';
          String displayMessage = errorMessage;
          if (errorMessage.contains('Không thể sửa') ||
              errorMessage.contains('đã được Chấp nhận') ||
              errorMessage.contains('đã được Từ chối')) {
            displayMessage = s.scheduleCannotEditError;
          } else if (errorMessage.isNotEmpty) {
            displayMessage = errorMessage;
          } else {
            displayMessage = s.action_failed;
          }

          CustomToast.show(context, displayMessage, type: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        String errorMsg = s.action_failed;
        if (e.toString().contains('Không thể sửa') ||
            e.toString().contains('400')) {
          errorMsg = s.scheduleCannotEditError;
        }
        CustomToast.show(context, errorMsg, type: ToastType.error);
      }
    }
  }

  Future<void> _refreshOfferDetail() async {
    await ref.read(offerViewModelProvider.notifier).fetchOfferDetail(offerId);
  }

  void _showErrorToast(S s) {
    CustomToast.show(
      context,
      ref.read(offerViewModelProvider).errorMessage ?? s.action_failed,
      type: ToastType.error,
    );
  }
}
