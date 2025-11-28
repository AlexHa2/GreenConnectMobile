import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/feedback_entity.dart';

class FeedbackModel {
  final String feedbackId;
  final String transactionId;
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
      feedbackId: json['feedbackId'] ?? '',
      transactionId: json['transactionId'] ?? '',
      reviewerId: json['reviewerId'] ?? '',
      reviewer: UserModel.fromJson(json['reviewer'] ?? {}),
      revieweeId: json['revieweeId'] ?? '',
      reviewee: UserModel.fromJson(json['reviewee'] ?? {}),
      rate: json['rate'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  FeedbackEntity toEntity() {
    return FeedbackEntity(
      feedbackId: feedbackId,
      transactionId: transactionId,
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
