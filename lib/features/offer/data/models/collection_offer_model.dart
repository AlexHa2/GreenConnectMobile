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
    // Build a map of scrapCategoryId -> imageUrl from scrapPostDetails
    final Map<int, String?> imageUrlMap = {};
    if (json['scrapPost'] != null &&
        json['scrapPost']['scrapPostDetails'] != null) {
      for (var detail in json['scrapPost']['scrapPostDetails'] as List) {
        final categoryId = detail['scrapCategoryId'] as int?;
        final imageUrl = detail['imageUrl'] as String?;
        if (categoryId != null) {
          imageUrlMap[categoryId] = imageUrl;
        }
      }
    }

    // Parse offerDetails and inject imageUrl
    final List<OfferDetailModel> offerDetailsList = [];
    if (json['offerDetails'] != null) {
      for (var offerDetailJson in json['offerDetails'] as List) {
        final categoryId = offerDetailJson['scrapCategoryId'] as int?;
        // Inject imageUrl from the map
        if (categoryId != null && imageUrlMap.containsKey(categoryId)) {
          offerDetailJson['imageUrl'] = imageUrlMap[categoryId];
        }
        offerDetailsList.add(OfferDetailModel.fromJson(offerDetailJson));
      }
    }

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
      offerDetails: offerDetailsList,
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
