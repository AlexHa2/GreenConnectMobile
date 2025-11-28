class TransactionDetailRequest {
  final int scrapCategoryId;
  final double pricePerUnit;
  final String unit;
  final double quantity;

  TransactionDetailRequest({
    required this.scrapCategoryId,
    required this.pricePerUnit,
    required this.unit,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'scrapCategoryId': scrapCategoryId,
        'pricePerUnit': pricePerUnit,
        'unit': unit,
        'quantity': quantity,
      };
}
