import 'package:GreenConnectMobile/features/offer/data/models/collection_offer_model.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_detail_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionModel {
  final String transactionId;
  final String householdId;
  final UserModel household;
  final String scrapCollectorId;
  final UserModel scrapCollector;
  final String offerId;
  final CollectionOfferModel? offer;
  final String status;
  final DateTime? scheduledTime;
  final DateTime? checkInTime;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<TransactionDetailModel> transactionDetails;
  final double totalPrice;

  TransactionModel({
    required this.transactionId,
    required this.householdId,
    required this.household,
    required this.scrapCollectorId,
    required this.scrapCollector,
    required this.offerId,
    this.offer,
    required this.status,
    this.scheduledTime,
    this.checkInTime,
    required this.createdAt,
    this.updatedAt,
    this.transactionDetails = const [],
    this.totalPrice = 0,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'] ?? '',
      householdId: json['householdId'] ?? '',
      household: UserModel.fromJson(json['household'] ?? {}),
      scrapCollectorId: json['scrapCollectorId'] ?? '',
      scrapCollector: UserModel.fromJson(json['scrapCollector'] ?? {}),
      offerId: json['offerId'] ?? '',
      offer: json['offer'] != null
          ? CollectionOfferModel.fromJson(json['offer'])
          : null,
      status: json['status'] ?? 'Scheduled',
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'])
          : null,
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      transactionDetails: json['transactionDetails'] != null
          ? (json['transactionDetails'] as List)
              .map((e) => TransactionDetailModel.fromJson(e))
              .toList()
          : [],
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'householdId': householdId,
        'household': household.toJson(),
        'scrapCollectorId': scrapCollectorId,
        'scrapCollector': scrapCollector.toJson(),
        'offerId': offerId,
        'offer': offer?.toJson(),
        'status': status,
        'scheduledTime': scheduledTime?.toIso8601String(),
        'checkInTime': checkInTime?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'transactionDetails':
            transactionDetails.map((e) => e.toJson()).toList(),
        'totalPrice': totalPrice,
      };

  TransactionEntity toEntity() {
    return TransactionEntity(
      transactionId: transactionId,
      householdId: householdId,
      household: household.toEntity(),
      scrapCollectorId: scrapCollectorId,
      scrapCollector: scrapCollector.toEntity(),
      offerId: offerId,
      offer: offer?.toEntity(),
      status: status,
      scheduledTime: scheduledTime,
      checkInTime: checkInTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
      transactionDetails: transactionDetails.map((e) => e.toEntity()).toList(),
      totalPrice: totalPrice,
    );
  }
}
