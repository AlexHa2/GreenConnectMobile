import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';

enum OfferStatus {
  pending,
  accepted,
  rejected,
  canceled;

  String toJson() => name;

  String get label {
    switch (this) {
      case OfferStatus.pending:
        return 'Pending';
      case OfferStatus.accepted:
        return 'Accepted';
      case OfferStatus.rejected:
        return 'Rejected';
      case OfferStatus.canceled:
        return 'Canceled';
    }
  }

  static OfferStatus fromJson(String json) => values.firstWhere(
    (e) => e.name.toLowerCase() == json.toLowerCase(),
    orElse: () => OfferStatus.pending,
  );

  static OfferStatus parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OfferStatus.pending;
      case 'accepted':
        return OfferStatus.accepted;
      case 'rejected':
        return OfferStatus.rejected;
      case 'canceled':
        return OfferStatus.canceled;
      default:
        return OfferStatus.pending;
    }
  }

  static String labelS(BuildContext context, OfferStatus status) {
    final s = S.of(context)!;

    switch (status) {
      case OfferStatus.pending:
        return s.pending;
      case OfferStatus.accepted:
        return s.accepted;
      case OfferStatus.rejected:
        return s.rejected;
      case OfferStatus.canceled:
        return s.canceled;
    }
  }
}

enum ScheduleProposalStatus {
  pending,
  accepted,
  rejected;

  String toJson() => name;

  String get label {
    switch (this) {
      case ScheduleProposalStatus.pending:
        return 'Pending';
      case ScheduleProposalStatus.accepted:
        return 'Accepted';
      case ScheduleProposalStatus.rejected:
        return 'Rejected';
    }
  }

  static ScheduleProposalStatus fromJson(String json) => values.firstWhere(
    (e) => e.name.toLowerCase() == json.toLowerCase(),
    orElse: () => ScheduleProposalStatus.pending,
  );

  static ScheduleProposalStatus parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ScheduleProposalStatus.pending;
      case 'accepted':
        return ScheduleProposalStatus.accepted;
      case 'rejected':
        return ScheduleProposalStatus.rejected;
      default:
        return ScheduleProposalStatus.pending;
    }
  }

  static String labelS(BuildContext context, ScheduleProposalStatus status) {
    final s = S.of(context)!;

    switch (status) {
      case ScheduleProposalStatus.pending:
        return s.pending;
      case ScheduleProposalStatus.accepted:
        return s.accepted;
      case ScheduleProposalStatus.rejected:
        return s.rejected;
    }
  }
}
