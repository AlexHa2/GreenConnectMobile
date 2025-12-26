class CreateOfferRequestEntity {
  final List<OfferDetailRequest> offerDetails;


  CreateOfferRequestEntity({
    required this.offerDetails,
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
