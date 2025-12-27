import 'package:GreenConnectMobile/features/offer/domain/entities/offer_detail_entity.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_category/scrap_category_model.dart';

class OfferDetailModel {
  final String offerDetailId;
  final String collectionOfferId;
  final String scrapCategoryId;
  final ScrapCategoryModel? scrapCategory;
  final double pricePerUnit;
  final double? pricePerKg;
  final String unit;
  final String? type;
  final String? imageUrl;

  OfferDetailModel({
    required this.offerDetailId,
    required this.collectionOfferId,
    required this.scrapCategoryId,
    this.scrapCategory,
    required this.pricePerUnit,
    this.pricePerKg,
    required this.unit,
    this.type,
    this.imageUrl,
  });

  factory OfferDetailModel.fromJson(Map<String, dynamic> json) {
    final dynamic idRaw = json['scrapCategoryId'];
    return OfferDetailModel(
      offerDetailId: json['offerDetailId'],
      collectionOfferId: json['collectionOfferId'],
      scrapCategoryId: idRaw?.toString() ?? '',
      scrapCategory: json['scrapCategory'] != null
          ? ScrapCategoryModel.fromJson(json['scrapCategory'])
          : null,
      pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble() ?? 0.0,
      pricePerKg: json['pricePerKg'] != null
          ? (json['pricePerKg'] as num).toDouble()
          : null,
      unit: json['unit'] ?? '',
      type: json['type'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerDetailId': offerDetailId,
      'collectionOfferId': collectionOfferId,
      'scrapCategoryId': scrapCategoryId,
      'scrapCategory': scrapCategory?.toJson(),
      'pricePerUnit': pricePerUnit,
      if (pricePerKg != null) 'pricePerKg': pricePerKg,
      'unit': unit,
      if (type != null) 'type': type,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  OfferDetailEntity toEntity() {
    return OfferDetailEntity(
      offerDetailId: offerDetailId,
      collectionOfferId: collectionOfferId,
      scrapCategoryId: scrapCategoryId,
      scrapCategory: scrapCategory?.toEntity(),
      pricePerUnit: pricePerUnit,
      pricePerKg: pricePerKg,
      unit: unit,
      type: type,
      imageUrl: imageUrl,
    );
  }
}
