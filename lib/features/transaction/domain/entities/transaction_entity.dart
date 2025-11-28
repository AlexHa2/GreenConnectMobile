import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_entity.dart';

class TransactionEntity {
  final String transactionId;
  final String householdId;
  final UserEntity household;
  final String scrapCollectorId;
  final UserEntity scrapCollector;
  final String offerId;
  final CollectionOfferEntity? offer;
  final String status; // Scheduled, InProgress, Completed, Canceled
  final DateTime scheduledTime;
  final DateTime? checkInTime;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<TransactionDetailEntity> transactionDetails;
  final double totalPrice;

  TransactionEntity({
    required this.transactionId,
    required this.householdId,
    required this.household,
    required this.scrapCollectorId,
    required this.scrapCollector,
    required this.offerId,
    this.offer,
    required this.status,
    required this.scheduledTime,
    this.checkInTime,
    required this.createdAt,
    this.updatedAt,
    this.transactionDetails = const [],
    this.totalPrice = 0,
  });

  /// Get parsed TransactionStatus enum from string status
  TransactionStatus get statusEnum => TransactionStatus.fromString(status);
}
