class UpdateFeedbackRequest {
  final int? rate;
  final String? comment;

  UpdateFeedbackRequest({
    this.rate,
    this.comment,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (rate != null) params['rate'] = rate;
    if (comment != null) params['comment'] = comment;
    return params;
  }
}
