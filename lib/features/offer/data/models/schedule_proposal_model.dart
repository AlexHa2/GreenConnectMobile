import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/schedule_proposal_entity.dart';

class ScheduleProposalModel {
  final String scheduleProposalId;
  final String collectionOfferId;
  final DateTime proposedTime;
  final ScheduleProposalStatus status;
  final DateTime createdAt;
  final String responseMessage;

  ScheduleProposalModel({
    required this.scheduleProposalId,
    required this.collectionOfferId,
    required this.proposedTime,
    required this.status,
    required this.createdAt,
    required this.responseMessage,
  });

  factory ScheduleProposalModel.fromJson(Map<String, dynamic> json) {
    return ScheduleProposalModel(
      scheduleProposalId: json['scheduleProposalId'],
      collectionOfferId: json['collectionOfferId'],
      proposedTime: DateTime.parse(json['proposedTime']),
      status: ScheduleProposalStatus.parseStatus(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      responseMessage: json['responseMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleProposalId': scheduleProposalId,
      'collectionOfferId': collectionOfferId,
      'proposedTime': proposedTime.toIso8601String(),
      'status': status.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'responseMessage': responseMessage,
    };
  }

  ScheduleProposalEntity toEntity() {
    return ScheduleProposalEntity(
      scheduleProposalId: scheduleProposalId,
      collectionOfferId: collectionOfferId,
      proposedTime: proposedTime,
      status: status,
      createdAt: createdAt,
      responseMessage: responseMessage,
    );
  }
}
