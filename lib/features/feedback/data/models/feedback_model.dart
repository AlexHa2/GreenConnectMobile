import 'package:GreenConnectMobile/features/feedback/domain/entities/feedback_entity.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_model.dart';

class FeedbackModel {
  final String feedbackId;
  final String transactionId;
  final TransactionModel? transaction;
  final String reviewerId;
  final UserModel reviewer;
  final String revieweeId;
  final UserModel reviewee;
  final int rate;
  final String comment;
  final DateTime createdAt;

  FeedbackModel({
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

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedbackId: json['feedbackId'] as String? ?? '',
      transactionId: json['transactionId'] as String? ?? '',
      transaction: json['transaction'] != null
          ? TransactionModel.fromJson(json['transaction'] as Map<String, dynamic>)
          : null,
      reviewerId: json['reviewerId'] as String? ?? '',
      reviewer: json['reviewer'] != null
          ? UserModel.fromJson(json['reviewer'] as Map<String, dynamic>)
          : UserModel(
              userId: '',
              fullName: 'Unknown',
              phoneNumber: '',
              pointBalance: 0,
              rank: 'Bronze',
              roles: [],
              avatarUrl: null,
            ),
      revieweeId: json['revieweeId'] as String? ?? '',
      reviewee: json['reviewee'] != null
          ? UserModel.fromJson(json['reviewee'] as Map<String, dynamic>)
          : UserModel(
              userId: '',
              fullName: 'Unknown',
              phoneNumber: '',
              pointBalance: 0,
              rank: 'Bronze',
              roles: [],
              avatarUrl: null,
            ),
      rate: (json['rate'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'feedbackId': feedbackId,
        'transactionId': transactionId,
        'transaction': transaction?.toJson(),
        'reviewerId': reviewerId,
        'reviewer': reviewer.toJson(),
        'revieweeId': revieweeId,
        'reviewee': reviewee.toJson(),
        'rate': rate,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };

  FeedbackEntity toEntity() {
    return FeedbackEntity(
      feedbackId: feedbackId,
      transactionId: transactionId,
      transaction: transaction?.toEntity(),
      reviewerId: reviewerId,
      reviewer: reviewer.toEntity(),
      revieweeId: revieweeId,
      reviewee: reviewee.toEntity(),
      rate: rate,
      comment: comment,
      createdAt: createdAt,
    );
  }
}
