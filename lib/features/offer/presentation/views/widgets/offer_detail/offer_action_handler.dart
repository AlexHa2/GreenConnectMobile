import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/features/offer/presentation/providers/offer_providers.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/confirm_dialog_helper.dart';
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
    final s = S.of(context)!;
    
    // Get current offer data to check for pending schedules
    final offerState = ref.read(offerViewModelProvider);
    final offer = offerState.detailData;
    final hasPendingSchedules = offer?.scheduleProposals.any(
      (schedule) => schedule.status == ScheduleProposalStatus.pending,
    ) ?? false;

    // Show enhanced confirmation dialog
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
      // First accept all pending schedules
      if (hasPendingSchedules && offer != null) {
        for (final schedule in offer.scheduleProposals) {
          if (schedule.status == ScheduleProposalStatus.pending) {
            await ref
                .read(scheduleViewModelProvider.notifier)
                .processSchedule(
                  scheduleId: schedule.scheduleProposalId,
                  isAccepted: true,
                );
          }
        }
      }

      // Then accept the offer
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
    final hasPendingSchedules = offer?.scheduleProposals.any(
      (schedule) => schedule.status == ScheduleProposalStatus.pending,
    ) ?? false;

    // Show enhanced confirmation dialog
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
      // First reject all pending schedules
      if (hasPendingSchedules && offer != null) {
        for (final schedule in offer.scheduleProposals) {
          if (schedule.status == ScheduleProposalStatus.pending) {
            await ref
                .read(scheduleViewModelProvider.notifier)
                .processSchedule(
                  scheduleId: schedule.scheduleProposalId,
                  isAccepted: false,
                );
          }
        }
      }

      // Then reject the offer
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
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: isAccepted ? s.scheduleConfirmAccept : s.scheduleConfirmReject,
      message: isAccepted ? s.scheduleAcceptMessage : s.scheduleRejectMessage,
      confirmText: isAccepted ? s.scheduleAcceptButton : s.scheduleRejectButton,
      isDestructive: !isAccepted,
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(scheduleViewModelProvider.notifier)
          .processSchedule(scheduleId: scheduleId, isAccepted: isAccepted);

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            isAccepted ? s.scheduleAcceptSuccess : s.scheduleRejectSuccess,
            type: ToastType.success,
          );
          await _refreshOfferDetail();
          onActionCompleted?.call();
        } else {
          CustomToast.show(
            context,
            ref.read(scheduleViewModelProvider).errorMessage ?? s.action_failed,
            type: ToastType.error,
          );
        }
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
