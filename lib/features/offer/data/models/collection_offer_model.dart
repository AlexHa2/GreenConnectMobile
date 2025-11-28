import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/features/offer/data/models/collector_model.dart';
import 'package:GreenConnectMobile/features/offer/data/models/offer_detail_model.dart';
import 'package:GreenConnectMobile/features/offer/data/models/schedule_proposal_model.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_model.dart';

class CollectionOfferModel {
  final String collectionOfferId;
  final String scrapPostId;
  final ScrapPostModel? scrapPost;
  final CollectorModel? scrapCollector;
  final OfferStatus status;
  final DateTime createdAt;
  final List<OfferDetailModel> offerDetails;
  final List<ScheduleProposalModel> scheduleProposals;

  CollectionOfferModel({
    required this.collectionOfferId,
    required this.scrapPostId,
    this.scrapPost,
    this.scrapCollector,
    required this.status,
    required this.createdAt,
    required this.offerDetails,
    required this.scheduleProposals,
  });

  factory CollectionOfferModel.fromJson(Map<String, dynamic> json) {
    return CollectionOfferModel(
      collectionOfferId: json['collectionOfferId'],
      scrapPostId: json['scrapPostId'],
      scrapPost: json['scrapPost'] != null
          ? ScrapPostModel.fromJson(json['scrapPost'])
          : null,
      scrapCollector: json['scrapCollector'] != null
          ? CollectorModel.fromJson(json['scrapCollector'])
          : json['collector'] != null
              ? CollectorModel.fromJson(json['collector'])
              : null,
      status: OfferStatus.parseStatus(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      offerDetails: json['offerDetails'] != null
          ? (json['offerDetails'] as List)
              .map((e) => OfferDetailModel.fromJson(e))
              .toList()
          : [],
      scheduleProposals: json['scheduleProposals'] != null
          ? (json['scheduleProposals'] as List)
              .map((e) => ScheduleProposalModel.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionOfferId': collectionOfferId,
      'scrapPostId': scrapPostId,
      'status': status.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'offerDetails': offerDetails.map((e) => e.toJson()).toList(),
      'scheduleProposals': scheduleProposals.map((e) => e.toJson()).toList(),
    };
  }

  CollectionOfferEntity toEntity() {
    return CollectionOfferEntity(
      collectionOfferId: collectionOfferId,
      scrapPostId: scrapPostId,
      scrapPost: scrapPost?.toEntity(),
      scrapCollector: scrapCollector?.toEntity(),
      status: status,
      createdAt: createdAt,
      offerDetails: offerDetails.map((e) => e.toEntity()).toList(),
      scheduleProposals: scheduleProposals.map((e) => e.toEntity()).toList(),
    );
  }
}
