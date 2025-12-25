import 'package:GreenConnectMobile/features/post/domain/entities/analyze_scrap_entity.dart';

class AnalyzedScrapItemModel {
  final String itemName;
  final num? estimatedQuantity;
  final String? unit;
  final String? suggestedCategoryId;
  final String? categoryName;
  final String? confidence;
  final String? imageUrl;

  AnalyzedScrapItemModel({
    required this.itemName,
    this.estimatedQuantity,
    this.unit,
    this.suggestedCategoryId,
    this.categoryName,
    this.confidence,
    this.imageUrl,
  });

  factory AnalyzedScrapItemModel.fromJson(Map<String, dynamic> json) {
    return AnalyzedScrapItemModel(
      itemName: json['itemName'] ?? '',
      estimatedQuantity: json['estimatedQuantity'],
      unit: json['unit'],
      suggestedCategoryId: json['suggestedCategoryId'],
      categoryName: json['categoryName'],
      confidence: json['confidence'],
      imageUrl: json['imageUrl'],
    );
  }

  AnalyzeScrapItemEntity toEntity() {
    return AnalyzeScrapItemEntity(
      itemName: itemName,
      estimatedQuantity: estimatedQuantity,
      unit: unit,
      suggestedCategoryId: suggestedCategoryId,
      categoryName: categoryName,
      confidence: confidence,
      imageUrl: imageUrl,
    );
  }
}

