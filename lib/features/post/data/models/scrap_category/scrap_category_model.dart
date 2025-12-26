import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';

class ScrapCategoryModel {
  final String scrapCategoryId;
  final String categoryName;
  final String? description;

  ScrapCategoryModel({
    required this.scrapCategoryId,
    required this.categoryName,
    this.description,
  });

  /// ⬇ From JSON
  factory ScrapCategoryModel.fromJson(Map<String, dynamic> json) {
    final dynamic idRaw = json['id'] ?? json['scrapCategoryId'];
    final dynamic nameRaw = json['name'] ?? json['categoryName'];
    return ScrapCategoryModel(
      scrapCategoryId: idRaw?.toString() ?? '',
      categoryName: nameRaw as String? ?? '',
      description: json['description'] as String?,
    );
  }

  /// ⬆ To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': scrapCategoryId,
      'name': categoryName,
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
