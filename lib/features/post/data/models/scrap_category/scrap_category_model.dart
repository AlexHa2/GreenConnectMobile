import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';
class ScrapCategoryModel {
  final int scrapCategoryId;
  final String categoryName;
  final String? description;

  ScrapCategoryModel({
    required this.scrapCategoryId,
    required this.categoryName,
    this.description,
  });

  /// ⬇ From JSON
  factory ScrapCategoryModel.fromJson(Map<String, dynamic> json) {
    return ScrapCategoryModel(
      scrapCategoryId: json['scrapCategoryId'],
      categoryName: json['categoryName'],
      description: json['description'],
    );
  }

  /// ⬆ To JSON
  Map<String, dynamic> toJson() {
    return {
      'scrapCategoryId': scrapCategoryId,
      'categoryName': categoryName,
      'description': description,
    };
  }

  /// Model -> Entity
  ScrapCategoryEntity toEntity() {
    return ScrapCategoryEntity(
      scrapCategoryId: scrapCategoryId,
      categoryName: categoryName,
      description: description,
    );
  }
}
