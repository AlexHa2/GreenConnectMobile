import 'package:GreenConnectMobile/features/feedback/data/models/feedback_list_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedbackModel JSON Parsing', () {
    test('should parse feedback list response correctly', () {
      // Given - Real API response
      final jsonResponse = {
        "data": [
          {
            "feedbackId": "a442fff7-5258-49bf-bd15-d4e43b80f82c",
            "transactionId": "7f2c8c75-7f67-4775-ad68-bbae455bba9a",
            "transaction": {
              "transactionId": "7f2c8c75-7f67-4775-ad68-bbae455bba9a",
              "householdId": "c79e5c99-7476-4cc2-bf94-2ed1f04593c1",
              "household": null,
              "scrapCollectorId": "fcae82f1-ec92-4939-8f7b-b89a2a32fc80",
              "scrapCollector": null,
              "offerId": "244d8f3e-9b09-4e2c-b867-7e951a74c788",
              "offer": null,
              "status": "Completed",
              "scheduledTime": "2025-11-27T17:26:31.467Z",
              "checkInTime": null,
              "createdAt": "2025-11-27T18:07:21.119662Z",
              "updatedAt": "2025-11-28T21:28:02.743111Z",
              "transactionDetails": [],
              "totalPrice": 0,
            },
            "reviewerId": "c79e5c99-7476-4cc2-bf94-2ed1f04593c1",
            "reviewer": {
              "id": "c79e5c99-7476-4cc2-bf94-2ed1f04593c1",
              "fullName": "household",
              "phoneNumber": "+84987654321",
              "pointBalance": 0,
              "rank": "Bronze",
              "roles": [],
              "avatarUrl": null,
            },
            "revieweeId": "fcae82f1-ec92-4939-8f7b-b89a2a32fc80",
            "reviewee": {
              "id": "fcae82f1-ec92-4939-8f7b-b89a2a32fc80",
              "fullName": "collector",
              "phoneNumber": "+84367355275",
              "pointBalance": 0,
              "rank": "Bronze",
              "roles": [],
              "avatarUrl": null,
            },
            "rate": 5,
            "comment": "nicer theo tiếng hàn",
            "createdAt": "2025-11-28T21:29:12.003681Z",
          }
        ],
        "pagination": {
          "totalRecords": 1,
          "currentPage": 1,
          "totalPages": 1,
          "nextPage": null,
          "prevPage": null,
        },
      };

      // When - Parse the response
      final model = FeedbackListResponseModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Verify the data is parsed correctly
      expect(entity.data.length, 1);
      expect(entity.data[0].feedbackId, 'a442fff7-5258-49bf-bd15-d4e43b80f82c');
      expect(entity.data[0].rate, 5);
      expect(entity.data[0].comment, 'nicer theo tiếng hàn');
      expect(entity.data[0].reviewer.fullName, 'household');
      expect(entity.data[0].reviewee.fullName, 'collector');
      expect(entity.data[0].reviewer.avatarUrl, null);
      expect(entity.data[0].reviewee.avatarUrl, null);
      expect(entity.data[0].transaction, isNotNull);
      
      expect(entity.pagination.totalRecords, 1);
      expect(entity.pagination.currentPage, 1);
      expect(entity.pagination.nextPage, null);
    });

    test('should handle null transaction gracefully', () {
      // Given - Response with null transaction
      final jsonResponse = {
        "data": [
          {
            "feedbackId": "test-id",
            "transactionId": "trans-id",
            "transaction": null,
            "reviewerId": "reviewer-id",
            "reviewer": {
              "id": "reviewer-id",
              "fullName": "Test Reviewer",
              "phoneNumber": "+84123456789",
              "pointBalance": 100,
              "rank": "Silver",
              "roles": ["household"],
              "avatarUrl": "https://example.com/avatar.jpg",
            },
            "revieweeId": "reviewee-id",
            "reviewee": {
              "id": "reviewee-id",
              "fullName": "Test Reviewee",
              "phoneNumber": "+84987654321",
              "pointBalance": 50,
              "rank": "Bronze",
              "roles": ["collector"],
              "avatarUrl": null,
            },
            "rate": 4,
            "comment": "Good service",
            "createdAt": "2025-11-29T10:00:00Z",
          }
        ],
        "pagination": {
          "totalRecords": 1,
          "currentPage": 1,
          "totalPages": 1,
          "nextPage": null,
          "prevPage": null,
        },
      };

      // When
      final model = FeedbackListResponseModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then
      expect(entity.data[0].transaction, null);
      expect(entity.data[0].reviewer.fullName, 'Test Reviewer');
      expect(entity.data[0].reviewer.avatarUrl, 'https://example.com/avatar.jpg');
      expect(entity.data[0].reviewee.avatarUrl, null);
    });

    test('should handle empty data array', () {
      // Given
      final jsonResponse = {
        "data": [],
        "pagination": {
          "totalRecords": 0,
          "currentPage": 1,
          "totalPages": 0,
          "nextPage": null,
          "prevPage": null,
        },
      };

      // When
      final model = FeedbackListResponseModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then
      expect(entity.data.isEmpty, true);
      expect(entity.pagination.totalRecords, 0);
    });
  });
}
