import 'package:GreenConnectMobile/features/offer/domain/entities/offer_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_category/scrap_category_model.dart';

class OfferDetailModel {
  final String offerDetailId;
  final String collectionOfferId;
  final int scrapCategoryId;
  final ScrapCategoryModel? scrapCategory;
  final double pricePerUnit;
  final String unit;

  OfferDetailModel({
    required this.offerDetailId,
    required this.collectionOfferId,
    required this.scrapCategoryId,
    this.scrapCategory,
    required this.pricePerUnit,
    required this.unit,
  });

  factory OfferDetailModel.fromJson(Map<String, dynamic> json) {
    return OfferDetailModel(
      offerDetailId: json['offerDetailId'],
      collectionOfferId: json['collectionOfferId'],
      scrapCategoryId: json['scrapCategoryId'],
      scrapCategory: json['scrapCategory'] != null
          ? ScrapCategoryModel.fromJson(json['scrapCategory'])
          : null,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerDetailId': offerDetailId,
      'collectionOfferId': collectionOfferId,
      'scrapCategoryId': scrapCategoryId,
      'scrapCategory': scrapCategory?.toJson(),
      'pricePerUnit': pricePerUnit,
      'unit': unit,
    };
  }

  OfferDetailEntity toEntity() {
    return OfferDetailEntity(
      offerDetailId: offerDetailId,
      collectionOfferId: collectionOfferId,
      scrapCategoryId: scrapCategoryId,
      scrapCategory: scrapCategory?.toEntity(),
      pricePerUnit: pricePerUnit,
      unit: unit,
    );
  }
}
