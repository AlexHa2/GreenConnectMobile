class CreateFeedbackRequest {
  final String transactionId;
  final int rate;
  final String comment;

  CreateFeedbackRequest({
    required this.transactionId,
    required this.rate,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'rate': rate,
        'comment': comment,
      };
}
