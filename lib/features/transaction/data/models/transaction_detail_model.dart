import 'package:GreenConnectMobile/features/post/data/models/scrap_category/scrap_category_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_entity.dart';

class TransactionDetailModel {
  final String transactionId;
  final int scrapCategoryId;
  final ScrapCategoryModel scrapCategory;
  final double pricePerUnit;
  final String unit;
  final double quantity;
  final double finalPrice;

  TransactionDetailModel({
    required this.transactionId,
    required this.scrapCategoryId,
    required this.scrapCategory,
    required this.pricePerUnit,
    required this.unit,
    required this.quantity,
    required this.finalPrice,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    return TransactionDetailModel(
      transactionId: json['transactionId'] ?? '',
      scrapCategoryId: json['scrapCategoryId'] ?? 0,
      scrapCategory: ScrapCategoryModel.fromJson(json['scrapCategory'] ?? {}),
      pricePerUnit: (json['pricePerUnit'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'scrapCategoryId': scrapCategoryId,
        'scrapCategory': scrapCategory.toJson(),
        'pricePerUnit': pricePerUnit,
        'unit': unit,
        'quantity': quantity,
        'finalPrice': finalPrice,
      };

  TransactionDetailEntity toEntity() {
    return TransactionDetailEntity(
      transactionId: transactionId,
      scrapCategoryId: scrapCategoryId,
      scrapCategory: scrapCategory.toEntity(),
      pricePerUnit: pricePerUnit,
      unit: unit,
      quantity: quantity,
      finalPrice: finalPrice,
    );
  }
}
