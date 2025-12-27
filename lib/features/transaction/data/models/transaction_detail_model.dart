import 'package:GreenConnectMobile/features/post/data/models/scrap_category/scrap_category_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_entity.dart';

class TransactionDetailModel {
  final String transactionId;
  final String scrapCategoryId;
  final ScrapCategoryModel scrapCategory;
  final double pricePerUnit;
  final String unit;
  final double quantity;
  final double finalPrice;
  final String type;

  TransactionDetailModel({
    required this.transactionId,
    required this.scrapCategoryId,
    required this.scrapCategory,
    required this.pricePerUnit,
    required this.unit,
    required this.quantity,
    required this.finalPrice,
    required this.type,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    final dynamic idRaw = json['scrapCategoryId'];
    return TransactionDetailModel(
      transactionId: json['transactionId'] ?? '',
      scrapCategoryId: idRaw?.toString() ?? '',
      scrapCategory: ScrapCategoryModel.fromJson(json['scrapCategory'] ?? {}),
      pricePerUnit: (json['pricePerUnit'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      type: json['type'] ?? '',
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
        'type': type,
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
      type: type,
    );
  }
}
