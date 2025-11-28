class CreateScheduleRequest {
  final String proposedTime;
  final String responseMessage;

  CreateScheduleRequest({
    required this.proposedTime,
    required this.responseMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'proposedTime': proposedTime,
      'responseMessage': responseMessage,
    };
  }
}
