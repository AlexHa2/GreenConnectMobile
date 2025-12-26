class AnalyzeScrapItemEntity {
  final String itemName;
  final num? estimatedQuantity;
  final String? unit;
  final String? suggestedCategoryId;
  final String? categoryName;
  final String? confidence;
  final String? imageUrl;

  const AnalyzeScrapItemEntity({
    required this.itemName,
    this.estimatedQuantity,
    this.unit,
    this.suggestedCategoryId,
    this.categoryName,
    this.confidence,
    this.imageUrl,
  });
}

class AnalyzeScrapResultEntity {
  final String suggestedTitle;
  final String suggestedDescription;
  final String? savedImageUrl;
  final String? savedImageFilePath;
  final List<AnalyzeScrapItemEntity> identifiedItems;

  const AnalyzeScrapResultEntity({
    required this.suggestedTitle,
    required this.suggestedDescription,
    this.savedImageUrl,
    this.savedImageFilePath,
    this.identifiedItems = const [],
  });
}

