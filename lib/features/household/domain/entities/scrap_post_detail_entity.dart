// scrap_post_detail_entity.dart
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_category_entity.dart';

class ScrapPostDetailEntity {
  final int scrapCategoryId;
  final ScrapCategoryEntity? scrapCategory;
  final String amountDescription;
  final String imageUrl;
  final String? status;

  ScrapPostDetailEntity({
    required this.scrapCategoryId,
    this.scrapCategory,
    required this.amountDescription,
    required this.imageUrl,
    this.status,
  });
}
