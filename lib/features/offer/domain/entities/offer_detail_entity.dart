import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';

class OfferDetailEntity {
  final String offerDetailId;
  final String collectionOfferId;
  final String scrapCategoryId;
  final ScrapCategoryEntity? scrapCategory;
  final double pricePerUnit;
  final double? pricePerKg;
  final String unit;
  final String? type;
  final String? imageUrl;

  OfferDetailEntity({
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
}
