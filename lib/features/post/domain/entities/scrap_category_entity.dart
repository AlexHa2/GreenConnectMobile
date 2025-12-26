class ScrapCategoryEntity {
  final String scrapCategoryId;
  final String categoryName;
  final String? description;

  ScrapCategoryEntity({
    required this.scrapCategoryId,
    required this.categoryName,
    this.description,
  });
}
