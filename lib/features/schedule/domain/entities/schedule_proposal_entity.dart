import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';

class ScheduleProposalEntity {
  final String scheduleProposalId;
  final String collectionOfferId;
  final CollectionOfferEntity? collectionOffer;
  final DateTime proposedTime;
  final ScheduleProposalStatus status;
  final DateTime createdAt;
  final String responseMessage;

  ScheduleProposalEntity({
    required this.scheduleProposalId,
    required this.collectionOfferId,
    this.collectionOffer,
    required this.proposedTime,
    required this.status,
    required this.createdAt,
    required this.responseMessage,
  });
}
