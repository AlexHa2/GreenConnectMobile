import 'package:GreenConnectMobile/features/post/domain/entities/scrap_category_entity.dart';

class TransactionDetailEntity {
  final String transactionId;
  final String scrapCategoryId;
  final ScrapCategoryEntity scrapCategory;
  final double pricePerUnit;
  final String unit;
  final double quantity;
  final double finalPrice;
  final String type;

  TransactionDetailEntity({
    required this.transactionId,
    required this.scrapCategoryId,
    required this.scrapCategory,
    required this.pricePerUnit,
    required this.unit,
    required this.quantity,
    required this.finalPrice,
    required this.type,
  });
}
