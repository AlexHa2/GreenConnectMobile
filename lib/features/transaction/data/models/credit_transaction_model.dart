import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/credit_transaction_entity.dart';

class CreditTransactionModel {
  final String id;
  final String userId;
  final UserModel user;
  final int amount;
  final int balanceAfter;
  final String type;
  final String referenceId;
  final String description;
  final DateTime createdAt;

  CreditTransactionModel({
    required this.id,
    required this.userId,
    required this.user,
    required this.amount,
    required this.balanceAfter,
    required this.type,
    required this.referenceId,
    required this.description,
    required this.createdAt,
  });

  factory CreditTransactionModel.fromJson(Map<String, dynamic> json) {
    return CreditTransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      amount: json['amount'] ?? 0,
      balanceAfter: json['balanceAfter'] ?? 0,
      type: json['type'] ?? '',
      referenceId: json['referenceId'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  CreditTransactionEntity toEntity() {
    return CreditTransactionEntity(
      id: id,
      userId: userId,
      user: user.toEntity(),
      amount: amount,
      balanceAfter: balanceAfter,
      type: type,
      referenceId: referenceId,
      description: description,
      createdAt: createdAt,
    );
  }
}
