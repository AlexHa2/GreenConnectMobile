class UpdateScheduleRequest {
  final DateTime proposedTime;
  final String responseMessage;

  UpdateScheduleRequest({
    required this.proposedTime,
    required this.responseMessage,
  });

  Map<String, String> toQueryParams() {
    return {
      'proposedTime': proposedTime.toUtc().toIso8601String(),
      'responseMessage': responseMessage,
    };
  }
}
