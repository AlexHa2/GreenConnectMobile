class CollectorReportEntity {
  final double totalEarning;
  final int totalFeedbacks;
  final double totalRating;
  final int totalComplaints;
  final List<StatusCount> complaints;
  final int totalAccused;
  final List<StatusCount> accused;
  final int totalOffers;
  final List<StatusCount> offers;
  final int totalTransactions;
  final List<StatusCount> transactions;

  CollectorReportEntity({
    required this.totalEarning,
    required this.totalFeedbacks,
    required this.totalRating,
    required this.totalComplaints,
    required this.complaints,
    required this.totalAccused,
    required this.accused,
    required this.totalOffers,
    required this.offers,
    required this.totalTransactions,
    required this.transactions,
  });
}

class StatusCount {
  final String status;
  final int count;

  StatusCount({
    required this.status,
    required this.count,
  });
}

