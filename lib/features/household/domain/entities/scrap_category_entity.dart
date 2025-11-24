class ScrapCategoryEntity {
  final int scrapCategoryId;
  final String categoryName;
  final String? description;

  ScrapCategoryEntity({
    required this.scrapCategoryId,
    required this.categoryName,
    this.description,
  });
}
