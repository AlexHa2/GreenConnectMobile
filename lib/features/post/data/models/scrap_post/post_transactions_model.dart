import 'package:GreenConnectMobile/features/offer/data/models/collection_offer_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/household_model.dart';
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/time_slot_model.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/transaction_entity.dart';

class PostTransactionsResponseModel {
  final List<TransactionModel> transactions;
  final double amountDifference;

  PostTransactionsResponseModel({
    required this.transactions,
    required this.amountDifference,
  });

  factory PostTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    return PostTransactionsResponseModel(
      transactions: (json['transactions'] as List?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      amountDifference: (json['amountDifference'] as num?)?.toDouble() ?? 0.0,
    );
  }

  PostTransactionsResponseEntity toEntity() {
    return PostTransactionsResponseEntity(
      transactions: transactions.map((e) => e.toEntity()).toList(),
      amountDifference: amountDifference,
    );
  }
}

class TransactionModel {
  final String transactionId;
  final String householdId;
  final HouseholdModel? household;
  final String scrapCollectorId;
  final HouseholdModel? scrapCollector;
  final String offerId;
  final CollectionOfferModel? offer;
  final String status;
  final DateTime? scheduledTime;
  final DateTime? checkInTime;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<TransactionDetailModel> transactionDetails;
  final String? timeSlotId;
  final TimeSlotModel? timeSlot;
  final double totalPrice;

  TransactionModel({
    required this.transactionId,
    required this.householdId,
    this.household,
    required this.scrapCollectorId,
    this.scrapCollector,
    required this.offerId,
    this.offer,
    required this.status,
    this.scheduledTime,
    this.checkInTime,
    required this.createdAt,
    this.updatedAt,
    required this.transactionDetails,
    this.timeSlotId,
    this.timeSlot,
    required this.totalPrice,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId']?.toString() ?? '',
      householdId: json['householdId']?.toString() ?? '',
      household: json['household'] != null
          ? HouseholdModel.fromJson(json['household'] as Map<String, dynamic>)
          : null,
      scrapCollectorId: json['scrapCollectorId']?.toString() ?? '',
      scrapCollector: json['scrapCollector'] != null
          ? HouseholdModel.fromJson(
              json['scrapCollector'] as Map<String, dynamic>)
          : null,
      offerId: json['offerId']?.toString() ?? '',
      offer: json['offer'] != null
          ? CollectionOfferModel.fromJson(
              json['offer'] as Map<String, dynamic>)
          : null,
      status: json['status']?.toString() ?? '',
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.tryParse(json['scheduledTime'].toString())
          : null,
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      transactionDetails: (json['transactionDetails'] as List?)
              ?.map((e) =>
                  TransactionDetailModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      timeSlotId: json['timeSlotId']?.toString(),
      timeSlot: json['timeSlot'] != null
          ? TimeSlotModel.fromJson(json['timeSlot'] as Map<String, dynamic>)
          : null,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      transactionId: transactionId,
      householdId: householdId,
      household: household?.toEntity(),
      scrapCollectorId: scrapCollectorId,
      scrapCollector: scrapCollector?.toEntity(),
      offerId: offerId,
      offer: offer?.toEntity(),
      status: status,
      scheduledTime: scheduledTime,
      checkInTime: checkInTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
      transactionDetails:
          transactionDetails.map((e) => e.toEntity()).toList(),
      timeSlotId: timeSlotId,
      timeSlot: timeSlot?.toEntity(),
      totalPrice: totalPrice,
    );
  }
}

class TransactionDetailModel {
  final String transactionId;
  final String scrapCategoryId;
  final ScrapCategoryModel? scrapCategory;
  final double pricePerUnit;
  final String unit;
  final double quantity;
  final double finalPrice;
  final String type;

  TransactionDetailModel({
    required this.transactionId,
    required this.scrapCategoryId,
    this.scrapCategory,
    required this.pricePerUnit,
    required this.unit,
    required this.quantity,
    required this.finalPrice,
    required this.type,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    return TransactionDetailModel(
      transactionId: json['transactionId']?.toString() ?? '',
      scrapCategoryId: json['scrapCategoryId']?.toString() ?? '',
      scrapCategory: json['scrapCategory'] != null
          ? ScrapCategoryModel.fromJson(
              json['scrapCategory'] as Map<String, dynamic>)
          : null,
      pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? '',
    );
  }

  TransactionDetailEntity toEntity() {
    return TransactionDetailEntity(
      transactionId: transactionId,
      scrapCategoryId: scrapCategoryId,
      scrapCategory: scrapCategory?.toEntity(),
      pricePerUnit: pricePerUnit,
      unit: unit,
      quantity: quantity,
      finalPrice: finalPrice,
      type: type,
    );
  }
}

class ScrapCategoryModel {
  final String id;
  final String name;
  final String? imageUrl;

  ScrapCategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory ScrapCategoryModel.fromJson(Map<String, dynamic> json) {
    return ScrapCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  ScrapCategoryEntity toEntity() {
    return ScrapCategoryEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
    );
  }
}

