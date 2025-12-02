class OfferItemData {
  final int categoryId;
  final String categoryName;
  double totalPrice;
  String unit;
  bool isSelected;

  OfferItemData({
    required this.categoryId,
    required this.categoryName,
    required this.totalPrice,
    required this.unit,
    required this.isSelected,
  });
}
