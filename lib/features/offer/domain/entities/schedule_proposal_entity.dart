import 'package:GreenConnectMobile/core/enum/offer_status.dart';

class ScheduleProposalEntity {
  final String scheduleProposalId;
  final String collectionOfferId;
  final DateTime proposedTime;
  final ScheduleProposalStatus status;
  final DateTime createdAt;
  final String responseMessage;

  ScheduleProposalEntity({
    required this.scheduleProposalId,
    required this.collectionOfferId,
    required this.proposedTime,
    required this.status,
    required this.createdAt,
    required this.responseMessage,
  });
}
