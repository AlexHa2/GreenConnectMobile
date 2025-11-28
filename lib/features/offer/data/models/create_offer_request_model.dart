import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';

class CreateOfferRequestModel {
  final List<OfferDetailRequestModel> offerDetails;
  final ScheduleProposalRequestModel scheduleProposal;

  CreateOfferRequestModel({
    required this.offerDetails,
    required this.scheduleProposal,
  });

  factory CreateOfferRequestModel.fromEntity(CreateOfferRequestEntity entity) {
    return CreateOfferRequestModel(
      offerDetails: entity.offerDetails
          .map((e) => OfferDetailRequestModel.fromEntity(e))
          .toList(),
      scheduleProposal:
          ScheduleProposalRequestModel.fromEntity(entity.scheduleProposal),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerDetails': offerDetails.map((e) => e.toJson()).toList(),
      'scheduleProposal': scheduleProposal.toJson(),
    };
  }
}

class OfferDetailRequestModel {
  final int scrapCategoryId;
  final double pricePerUnit;
  final String unit;

  OfferDetailRequestModel({
    required this.scrapCategoryId,
    required this.pricePerUnit,
    required this.unit,
  });

  factory OfferDetailRequestModel.fromEntity(OfferDetailRequest entity) {
    return OfferDetailRequestModel(
      scrapCategoryId: entity.scrapCategoryId,
      pricePerUnit: entity.pricePerUnit,
      unit: entity.unit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scrapCategoryId': scrapCategoryId,
      'pricePerUnit': pricePerUnit,
      'unit': unit,
    };
  }
}

class ScheduleProposalRequestModel {
  final DateTime proposedTime;
  final String responseMessage;

  ScheduleProposalRequestModel({
    required this.proposedTime,
    required this.responseMessage,
  });

  factory ScheduleProposalRequestModel.fromEntity(
      ScheduleProposalRequest entity) {
    return ScheduleProposalRequestModel(
      proposedTime: entity.proposedTime,
      responseMessage: entity.responseMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proposedTime': proposedTime.toIso8601String(),
      'responseMessage': responseMessage,
    };
  }
}
