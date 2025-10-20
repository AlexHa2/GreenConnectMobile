class DashboardStats {
  final double earningsToday;
  final int jobsAvailable;
  final double rating;

  const DashboardStats({
    required this.earningsToday,
    required this.jobsAvailable,
    required this.rating,
  });

  factory DashboardStats.empty() {
    return const DashboardStats(
      earningsToday: 0.0,
      jobsAvailable: 0,
      rating: 0.0,
    );
  }

  DashboardStats copyWith({
    double? earningsToday,
    int? jobsAvailable,
    double? rating,
  }) {
    return DashboardStats(
      earningsToday: earningsToday ?? this.earningsToday,
      jobsAvailable: jobsAvailable ?? this.jobsAvailable,
      rating: rating ?? this.rating,
    );
  }
}
