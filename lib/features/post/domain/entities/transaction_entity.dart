import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/household_entity.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';

class TransactionEntity {
  final String transactionId;
  final String householdId;
  final HouseholdEntity? household;
  final String scrapCollectorId;
  final HouseholdEntity? scrapCollector;
  final String offerId;
  final CollectionOfferEntity? offer;
  final String status;
  final DateTime? scheduledTime;
  final DateTime? checkInTime;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<TransactionDetailEntity> transactionDetails;
  final String? timeSlotId;
  final ScrapPostTimeSlotEntity? timeSlot;
  final double totalPrice;

  TransactionEntity({
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
}

class TransactionDetailEntity {
  final String transactionId;
  final String scrapCategoryId;
  final ScrapCategoryEntity? scrapCategory;
  final double pricePerUnit;
  final String unit;
  final double quantity;
  final double finalPrice;
  final String type;

  TransactionDetailEntity({
    required this.transactionId,
    required this.scrapCategoryId,
    this.scrapCategory,
    required this.pricePerUnit,
    required this.unit,
    required this.quantity,
    required this.finalPrice,
    required this.type,
  });
}

class ScrapCategoryEntity {
  final String id;
  final String name;
  final String? imageUrl;

  ScrapCategoryEntity({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}

class PostTransactionsResponseEntity {
  final List<TransactionEntity> transactions;
  final double amountDifference;

  PostTransactionsResponseEntity({
    required this.transactions,
    required this.amountDifference,
  });
}

