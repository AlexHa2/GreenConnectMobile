import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';

class CreateOfferRequestModel {
  final List<OfferDetailRequestModel> offerDetails;

  CreateOfferRequestModel({
    required this.offerDetails,
  });

  factory CreateOfferRequestModel.fromEntity(CreateOfferRequestEntity entity) {
    return CreateOfferRequestModel(
      offerDetails: entity.offerDetails
          .map((e) => OfferDetailRequestModel.fromEntity(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerDetails': offerDetails.map((e) => e.toJson()).toList(),
    };
  }

  /// JSON for create offer API (only offerDetails)
  Map<String, dynamic> toJsonForCreate() {
    return {
      'offerDetails': offerDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class OfferDetailRequestModel {
  final String scrapCategoryId;
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
      'proposedTime': proposedTime.toUtc().toIso8601String(),
      'responseMessage': responseMessage,
    };
  }
}
