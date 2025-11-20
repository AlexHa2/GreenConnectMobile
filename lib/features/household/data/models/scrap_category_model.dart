import 'package:GreenConnectMobile/features/household/domain/entities/scrap_category_entity.dart';

class ScrapCategoryModel extends ScrapCategoryEntity {
  ScrapCategoryModel({
    required super.scrapCategoryId,
    required super.categoryName,
    required super.description,
  });

  factory ScrapCategoryModel.fromJson(Map<String, dynamic> json) {
    return ScrapCategoryModel(
      scrapCategoryId: json['scrapCategoryId'],
      categoryName: json['categoryName'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'scrapCategoryId': scrapCategoryId,
    'categoryName': categoryName,
    'description': description,
  };

  ScrapCategoryEntity toEntity() {
    return ScrapCategoryEntity(
      scrapCategoryId: scrapCategoryId,
      categoryName: categoryName,
      description: description,
    );
  }
}
