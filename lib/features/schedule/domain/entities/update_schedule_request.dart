class UpdateScheduleRequest {
  final DateTime proposedTime;
  final String responseMessage;

  UpdateScheduleRequest({
    required this.proposedTime,
    required this.responseMessage,
  });

  Map<String, String> toQueryParams() {
    return {
      'proposedTime': proposedTime.toIso8601String(),
      'responseMessage': responseMessage,
    };
  }
}
