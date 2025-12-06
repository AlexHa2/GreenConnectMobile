import 'package:GreenConnectMobile/features/collector/domain/entities/collector_report_entity.dart';

class CollectorReportModel extends CollectorReportEntity {
  CollectorReportModel({
    required super.totalEarning,
    required super.totalFeedbacks,
    required super.totalRating,
    required super.totalComplaints,
    required super.complaints,
    required super.totalAccused,
    required super.accused,
    required super.totalOffers,
    required super.offers,
    required super.totalTransactions,
    required super.transactions,
  });

  factory CollectorReportModel.fromJson(Map<String, dynamic> json) {
    return CollectorReportModel(
      totalEarning: (json['totalEarning'] as num?)?.toDouble() ?? 0.0,
      totalFeedbacks: json['totalFeedbacks'] as int? ?? 0,
      totalRating: (json['totalRating'] as num?)?.toDouble() ?? 0.0,
      totalComplaints: json['totalComplaints'] as int? ?? 0,
      complaints: (json['complaints'] as List<dynamic>?)
              ?.map((e) => StatusCountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalAccused: json['totalAccused'] as int? ?? 0,
      accused: (json['accused'] as List<dynamic>?)
              ?.map((e) => StatusCountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalOffers: json['totalOffers'] as int? ?? 0,
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => StatusCountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalTransactions: json['totalTransactions'] as int? ?? 0,
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => StatusCountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  CollectorReportEntity toEntity() {
    return CollectorReportEntity(
      totalEarning: totalEarning,
      totalFeedbacks: totalFeedbacks,
      totalRating: totalRating,
      totalComplaints: totalComplaints,
      complaints: complaints,
      totalAccused: totalAccused,
      accused: accused,
      totalOffers: totalOffers,
      offers: offers,
      totalTransactions: totalTransactions,
      transactions: transactions,
    );
  }
}

class StatusCountModel extends StatusCount {
  StatusCountModel({
    required super.status,
    required super.count,
  });

  factory StatusCountModel.fromJson(Map<String, dynamic> json) {
    return StatusCountModel(
      status: json['status'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}

