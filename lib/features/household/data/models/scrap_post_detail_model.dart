import 'package:GreenConnectMobile/features/household/data/models/scrap_category_model.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_detai_entity.dart';

class ScrapPostDetailModel extends ScrapPostDetailEntity {
  ScrapPostDetailModel({
    required super.scrapCategoryId,
    super.scrapCategory,
    required super.amountDescription,
    required super.imageUrl,
    super.status,
  });

  factory ScrapPostDetailModel.fromJson(Map<String, dynamic> json) {
    return ScrapPostDetailModel(
      scrapCategoryId: json['scrapCategoryId'],
      scrapCategory: json['scrapCategory'] != null
          ? ScrapCategoryModel.fromJson(json['scrapCategory'])
          : null,
      amountDescription: json['amountDescription'],
      imageUrl: json['imageUrl'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'scrapCategoryId': scrapCategoryId,
    'amountDescription': amountDescription,
    'imageUrl': imageUrl,
  };

  ScrapPostDetailEntity toEntity() {
    return ScrapPostDetailEntity(
      scrapCategoryId: scrapCategoryId,
      scrapCategory: scrapCategory != null
          ? (scrapCategory as ScrapCategoryModel).toEntity()
          : null,
      amountDescription: amountDescription,
      imageUrl: imageUrl,
      status: status,
    );
  }
}
