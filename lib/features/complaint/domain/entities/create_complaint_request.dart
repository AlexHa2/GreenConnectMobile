class CreateComplaintRequest {
  final String transactionId;
  final String reason;
  final String evidenceUrl;

  CreateComplaintRequest({
    required this.transactionId,
    required this.reason,
    required this.evidenceUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'reason': reason,
      'evidenceUrl': evidenceUrl,
    };
  }
}
