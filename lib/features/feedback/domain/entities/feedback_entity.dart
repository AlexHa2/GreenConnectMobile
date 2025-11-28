import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';

class FeedbackEntity {
  final String feedbackId;
  final String transactionId;
  final TransactionEntity? transaction;
  final String reviewerId;
  final UserEntity reviewer;
  final String revieweeId;
  final UserEntity reviewee;
  final int rate;
  final String comment;
  final DateTime createdAt;

  FeedbackEntity({
    required this.feedbackId,
    required this.transactionId,
    this.transaction,
    required this.reviewerId,
    required this.reviewer,
    required this.revieweeId,
    required this.reviewee,
    required this.rate,
    required this.comment,
    required this.createdAt,
  });
}
