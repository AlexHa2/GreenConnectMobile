import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';

class OfferDetailEntity {
  final String offerDetailId;
  final String collectionOfferId;
  final String scrapCategoryId;
  final ScrapCategoryEntity? scrapCategory;
  final double pricePerUnit;
  final String unit;
  final String? imageUrl;

  OfferDetailEntity({
    required this.offerDetailId,
    required this.collectionOfferId,
    required this.scrapCategoryId,
    this.scrapCategory,
    required this.pricePerUnit,
    required this.unit,
    this.imageUrl,
  });
}
