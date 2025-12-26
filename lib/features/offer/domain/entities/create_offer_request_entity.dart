class CreateOfferRequestEntity {
  final List<OfferDetailRequest> offerDetails;
  final ScheduleProposalRequest scheduleProposal;

  CreateOfferRequestEntity({
    required this.offerDetails,
    required this.scheduleProposal,
  });
}

class OfferDetailRequest {
  final String scrapCategoryId;
  final double pricePerUnit;
  final String unit;

  OfferDetailRequest({
    required this.scrapCategoryId,
    required this.pricePerUnit,
    required this.unit,
  });
}

class ScheduleProposalRequest {
  final DateTime proposedTime;
  final String responseMessage;

  ScheduleProposalRequest({
    required this.proposedTime,
    required this.responseMessage,
  });
}
