import 'package:GreenConnectMobile/features/collector/data/models/collector_report_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CollectorReportModel JSON Parsing', () {
    test('should parse collector report response correctly', () {
      // Given - Real API response structure
      final jsonResponse = {
        "totalEarning": 1250.50,
        "totalFeedbacks": 15,
        "totalRating": 4.5,
        "totalComplaints": 2,
        "complaints": [
          {"status": "Pending", "count": 1},
          {"status": "Resolved", "count": 1}
        ],
        "totalAccused": 0,
        "accused": [],
        "totalOffers": 25,
        "offers": [
          {"status": "Accepted", "count": 20},
          {"status": "Pending", "count": 3},
          {"status": "Rejected", "count": 2}
        ],
        "totalTransactions": 20,
        "transactions": [
          {"status": "Completed", "count": 18},
          {"status": "Pending", "count": 2}
        ]
      };

      // When - Parse the response
      final model = CollectorReportModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Verify the data is parsed correctly
      expect(entity.totalEarning, 1250.50);
      expect(entity.totalFeedbacks, 15);
      expect(entity.totalRating, 4.5);
      expect(entity.totalComplaints, 2);
      expect(entity.complaints.length, 2);
      expect(entity.complaints[0].status, 'Pending');
      expect(entity.complaints[0].count, 1);
      expect(entity.complaints[1].status, 'Resolved');
      expect(entity.complaints[1].count, 1);
      
      expect(entity.totalAccused, 0);
      expect(entity.accused.isEmpty, true);
      
      expect(entity.totalOffers, 25);
      expect(entity.offers.length, 3);
      expect(entity.offers[0].status, 'Accepted');
      expect(entity.offers[0].count, 20);
      
      expect(entity.totalTransactions, 20);
      expect(entity.transactions.length, 2);
      expect(entity.transactions[0].status, 'Completed');
      expect(entity.transactions[0].count, 18);
    });

    test('should handle null values with default values', () {
      // Given - Response with null values
      final jsonResponse = {
        "totalEarning": null,
        "totalFeedbacks": null,
        "totalRating": null,
        "totalComplaints": null,
        "complaints": null,
        "totalAccused": null,
        "accused": null,
        "totalOffers": null,
        "offers": null,
        "totalTransactions": null,
        "transactions": null
      };

      // When
      final model = CollectorReportModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Should use default values
      expect(entity.totalEarning, 0.0);
      expect(entity.totalFeedbacks, 0);
      expect(entity.totalRating, 0.0);
      expect(entity.totalComplaints, 0);
      expect(entity.complaints.isEmpty, true);
      expect(entity.totalAccused, 0);
      expect(entity.accused.isEmpty, true);
      expect(entity.totalOffers, 0);
      expect(entity.offers.isEmpty, true);
      expect(entity.totalTransactions, 0);
      expect(entity.transactions.isEmpty, true);
    });

    test('should handle empty arrays', () {
      // Given - Response with empty arrays
      final jsonResponse = {
        "totalEarning": 0.0,
        "totalFeedbacks": 0,
        "totalRating": 0.0,
        "totalComplaints": 0,
        "complaints": [],
        "totalAccused": 0,
        "accused": [],
        "totalOffers": 0,
        "offers": [],
        "totalTransactions": 0,
        "transactions": []
      };

      // When
      final model = CollectorReportModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then
      expect(entity.complaints.isEmpty, true);
      expect(entity.accused.isEmpty, true);
      expect(entity.offers.isEmpty, true);
      expect(entity.transactions.isEmpty, true);
    });

    test('should handle missing fields', () {
      // Given - Response with missing fields
      final jsonResponse = <String, dynamic>{};

      // When
      final model = CollectorReportModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Should use default values
      expect(entity.totalEarning, 0.0);
      expect(entity.totalFeedbacks, 0);
      expect(entity.totalRating, 0.0);
      expect(entity.totalComplaints, 0);
      expect(entity.complaints.isEmpty, true);
      expect(entity.totalAccused, 0);
      expect(entity.accused.isEmpty, true);
      expect(entity.totalOffers, 0);
      expect(entity.offers.isEmpty, true);
      expect(entity.totalTransactions, 0);
      expect(entity.transactions.isEmpty, true);
    });

    test('should handle numeric types correctly (int vs double)', () {
      // Given - Response with int values that should be converted to double
      final jsonResponse = {
        "totalEarning": 1000, // int
        "totalRating": 4, // int
        "totalFeedbacks": 10,
        "totalComplaints": 0,
        "complaints": [],
        "totalAccused": 0,
        "accused": [],
        "totalOffers": 0,
        "offers": [],
        "totalTransactions": 0,
        "transactions": []
      };

      // When
      final model = CollectorReportModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Should convert int to double correctly
      expect(entity.totalEarning, 1000.0);
      expect(entity.totalRating, 4.0);
      expect(entity.totalFeedbacks, 10);
    });

    test('should parse StatusCount correctly', () {
      // Given
      final jsonStatusCount = {
        "status": "Completed",
        "count": 5
      };

      // When
      final statusCount = StatusCountModel.fromJson(jsonStatusCount);

      // Then
      expect(statusCount.status, 'Completed');
      expect(statusCount.count, 5);
    });

    test('should handle StatusCount with null values', () {
      // Given
      final jsonStatusCount = {
        "status": null,
        "count": null
      };

      // When
      final statusCount = StatusCountModel.fromJson(jsonStatusCount);

      // Then - Should use default values
      expect(statusCount.status, '');
      expect(statusCount.count, 0);
    });

    test('should handle StatusCount with missing fields', () {
      // Given
      final jsonStatusCount = <String, dynamic>{};

      // When
      final statusCount = StatusCountModel.fromJson(jsonStatusCount);

      // Then - Should use default values
      expect(statusCount.status, '');
      expect(statusCount.count, 0);
    });

    test('should handle complex collector report with all status types', () {
      // Given - Complete report with all possible statuses
      final jsonResponse = {
        "totalEarning": 5000.75,
        "totalFeedbacks": 50,
        "totalRating": 4.8,
        "totalComplaints": 5,
        "complaints": [
          {"status": "Pending", "count": 2},
          {"status": "InProgress", "count": 1},
          {"status": "Resolved", "count": 2}
        ],
        "totalAccused": 1,
        "accused": [
          {"status": "Pending", "count": 1}
        ],
        "totalOffers": 100,
        "offers": [
          {"status": "Accepted", "count": 80},
          {"status": "Pending", "count": 15},
          {"status": "Rejected", "count": 5}
        ],
        "totalTransactions": 80,
        "transactions": [
          {"status": "Completed", "count": 75},
          {"status": "Pending", "count": 3},
          {"status": "Cancelled", "count": 2}
        ]
      };

      // When
      final model = CollectorReportModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then
      expect(entity.totalEarning, 5000.75);
      expect(entity.totalFeedbacks, 50);
      expect(entity.totalRating, 4.8);
      
      // Verify complaints
      expect(entity.totalComplaints, 5);
      expect(entity.complaints.length, 3);
      final pendingComplaints = entity.complaints.firstWhere(
        (c) => c.status == 'Pending',
      );
      expect(pendingComplaints.count, 2);
      
      // Verify accused
      expect(entity.totalAccused, 1);
      expect(entity.accused.length, 1);
      expect(entity.accused[0].status, 'Pending');
      expect(entity.accused[0].count, 1);
      
      // Verify offers
      expect(entity.totalOffers, 100);
      expect(entity.offers.length, 3);
      final acceptedOffers = entity.offers.firstWhere(
        (o) => o.status == 'Accepted',
      );
      expect(acceptedOffers.count, 80);
      
      // Verify transactions
      expect(entity.totalTransactions, 80);
      expect(entity.transactions.length, 3);
      final completedTransactions = entity.transactions.firstWhere(
        (t) => t.status == 'Completed',
      );
      expect(completedTransactions.count, 75);
    });

    test('should convert model to entity correctly', () {
      // Given
      final model = CollectorReportModel(
        totalEarning: 1000.0,
        totalFeedbacks: 10,
        totalRating: 4.5,
        totalComplaints: 1,
        complaints: [
          StatusCountModel(status: 'Pending', count: 1)
        ],
        totalAccused: 0,
        accused: [],
        totalOffers: 5,
        offers: [
          StatusCountModel(status: 'Accepted', count: 5)
        ],
        totalTransactions: 5,
        transactions: [
          StatusCountModel(status: 'Completed', count: 5)
        ],
      );

      // When
      final entity = model.toEntity();

      // Then
      expect(entity.totalEarning, 1000.0);
      expect(entity.totalFeedbacks, 10);
      expect(entity.totalRating, 4.5);
      expect(entity.totalComplaints, 1);
      expect(entity.complaints.length, 1);
      expect(entity.complaints[0].status, 'Pending');
      expect(entity.complaints[0].count, 1);
      expect(entity.totalOffers, 5);
      expect(entity.offers.length, 1);
      expect(entity.totalTransactions, 5);
      expect(entity.transactions.length, 1);
    });
  });
}
