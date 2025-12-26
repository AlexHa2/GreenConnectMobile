import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/features/offer/data/models/collector_model.dart';
import 'package:GreenConnectMobile/features/offer/data/models/offer_detail_model.dart';
import 'package:GreenConnectMobile/features/offer/data/models/schedule_proposal_model.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/time_slot_model.dart';

class CollectionOfferModel {
  final String collectionOfferId;
  final String scrapPostId;
  final ScrapPostModel? scrapPost;
  final CollectorModel? scrapCollector;
  final OfferStatus status;
  final DateTime createdAt;
  final List<OfferDetailModel> offerDetails;
  final List<ScheduleProposalModel> scheduleProposals;
  final String? timeSlotId;
  final TimeSlotModel? timeSlot;

  CollectionOfferModel({
    required this.collectionOfferId,
    required this.scrapPostId,
    this.scrapPost,
    this.scrapCollector,
    required this.status,
    required this.createdAt,
    required this.offerDetails,
    required this.scheduleProposals,
    this.timeSlotId,
    this.timeSlot,
  });

  factory CollectionOfferModel.fromJson(Map<String, dynamic> json) {
    // Build a map of scrapCategoryId -> imageUrl from scrapPostDetails
    final Map<String, String?> imageUrlMap = {};
    if (json['scrapPost'] != null &&
        json['scrapPost']['scrapPostDetails'] != null) {
      final scrapPostDetails = json['scrapPost']['scrapPostDetails'];
      if (scrapPostDetails is List) {
        for (var detail in scrapPostDetails) {
          final dynamic idRaw = detail['scrapCategoryId'];
          final categoryId = idRaw?.toString();
          final imageUrl = detail['imageUrl'] as String?;
          if (categoryId != null && categoryId.isNotEmpty) {
            imageUrlMap[categoryId] = imageUrl;
          }
        }
      }
    }

    // Parse offerDetails and inject imageUrl
    final List<OfferDetailModel> offerDetailsList = [];
    if (json['offerDetails'] != null && json['offerDetails'] is List) {
      for (var offerDetailJson in json['offerDetails'] as List) {
        final dynamic idRaw = offerDetailJson['scrapCategoryId'];
        final categoryId = idRaw?.toString();
        // Inject imageUrl from the map
        if (categoryId != null && imageUrlMap.containsKey(categoryId)) {
          offerDetailJson['imageUrl'] = imageUrlMap[categoryId];
        }
        offerDetailsList.add(OfferDetailModel.fromJson(offerDetailJson));
      }
    }

    return CollectionOfferModel(
      collectionOfferId: json['collectionOfferId'] as String,
      scrapPostId: json['scrapPostId'] as String,
      scrapPost: json['scrapPost'] != null
          ? ScrapPostModel.fromJson(json['scrapPost'] as Map<String, dynamic>)
          : null,
      scrapCollector: json['scrapCollector'] != null
          ? CollectorModel.fromJson(json['scrapCollector'] as Map<String, dynamic>)
          : json['collector'] != null
          ? CollectorModel.fromJson(json['collector'] as Map<String, dynamic>)
          : null,
      status: OfferStatus.parseStatus(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      offerDetails: offerDetailsList,
      scheduleProposals: json['scheduleProposals'] != null && json['scheduleProposals'] is List
          ? (json['scheduleProposals'] as List)
                .map((e) => ScheduleProposalModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      timeSlotId: json['timeSlotId'] as String?,
      timeSlot: json['timeSlot'] != null
          ? TimeSlotModel.fromJson(json['timeSlot'] as Map<String, dynamic>)
          : null,
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
      timeSlotId: timeSlotId,
      timeSlot: timeSlot?.toEntity(),
    );
  }
}
