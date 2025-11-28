class UpdateComplaintRequest {
  final String? reason;
  final String? evidenceUrl;

  UpdateComplaintRequest({
    this.reason,
    this.evidenceUrl,
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (reason != null) {
      params['reason'] = reason!;
    }
    if (evidenceUrl != null) {
      params['evidenceUrl'] = evidenceUrl!;
    }
    return params;
  }
}
