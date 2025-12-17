import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';

class CreditTransactionEntity {
  final String id;
  final String userId;
  final UserEntity user;
  final int amount;
  final int balanceAfter;
  final String type;
  final String referenceId;
  final String description;
  final DateTime createdAt;

  CreditTransactionEntity({
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
}
