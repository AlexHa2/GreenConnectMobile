import 'package:GreenConnectMobile/features/transaction/data/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionModel - Collector Transaction Flow', () {
    test('should parse transaction correctly after schedule accepted', () {
      // Given - Transaction được tạo sau khi household chấp nhận lịch hẹn
      final jsonResponse = {
        "transactionId": "trans-123",
        "householdId": "household-456",
        "household": {
          "id": "household-456",
          "fullName": "Nguyễn Văn A",
          "phoneNumber": "+84987654321",
          "pointBalance": 500,
          "rank": "Silver",
          "roles": ["household"],
          "avatarUrl": null
        },
        "scrapCollectorId": "collector-789",
        "scrapCollector": {
          "id": "collector-789",
          "fullName": "Collector Name",
          "phoneNumber": "+84123456789",
          "pointBalance": 1000,
          "rank": "Gold",
          "roles": ["collector"],
          "avatarUrl": null
        },
        "offerId": "offer-123",
        "offer": null,
        "status": "Scheduled",
        "scheduledTime": "2025-12-10T14:00:00Z",
        "checkInTime": null,
        "createdAt": "2025-12-09T15:00:00Z",
        "updatedAt": null,
        "transactionDetails": [],
        "totalPrice": 0
      };

      // When
      final model = TransactionModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Transaction ở trạng thái Scheduled, chờ collector check-in
      expect(entity.transactionId, 'trans-123');
      expect(entity.status, 'Scheduled');
      expect(entity.scheduledTime, DateTime.parse('2025-12-10T14:00:00Z'));
      expect(entity.checkInTime, null); // Chưa check-in
      expect(entity.transactionDetails.isEmpty, true); // Chưa ghi số lượng
    });

    test('should parse transaction after check-in', () {
      // Given - Collector đã check-in
      final jsonResponse = {
        "transactionId": "trans-123",
        "householdId": "household-456",
        "household": {},
        "scrapCollectorId": "collector-789",
        "scrapCollector": {},
        "offerId": "offer-123",
        "status": "Pending",
        "scheduledTime": "2025-12-10T14:00:00Z",
        "checkInTime": "2025-12-10T14:05:00Z", // Đã check-in
        "createdAt": "2025-12-09T15:00:00Z",
        "transactionDetails": [],
        "totalPrice": 0
      };

      // When
      final model = TransactionModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Đã có checkInTime
      expect(entity.checkInTime, DateTime.parse('2025-12-10T14:05:00Z'));
      expect(entity.status, 'Pending'); // Đang chờ ghi số lượng
    });

    test('should parse transaction after recording quantities', () {
      // Given - Collector đã ghi số lượng
      final jsonResponse = {
        "transactionId": "trans-123",
        "householdId": "household-456",
        "household": {},
        "scrapCollectorId": "collector-789",
        "scrapCollector": {},
        "offerId": "offer-123",
        "status": "Pending",
        "scheduledTime": "2025-12-10T14:00:00Z",
        "checkInTime": "2025-12-10T14:05:00Z",
        "createdAt": "2025-12-09T15:00:00Z",
        "transactionDetails": [
          {
            "transactionId": "trans-123",
            "scrapCategoryId": 1,
            "scrapCategory": {
              "scrapCategoryId": 1,
              "name": "Nhựa PET",
              "unit": "kg"
            },
            "pricePerUnit": 5.5,
            "unit": "kg",
            "quantity": 48.5,
            "finalPrice": 266.75
          }
        ],
        "totalPrice": 266.75
      };

      // When
      final model = TransactionModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Đã có transaction details và totalPrice
      expect(entity.transactionDetails.length, 1);
      expect(entity.transactionDetails[0].quantity, 48.5);
      expect(entity.transactionDetails[0].finalPrice, 266.75);
      expect(entity.totalPrice, 266.75);
    });

    test('should parse completed transaction after payment', () {
      // Given - Đã thanh toán xong (cash hoặc bank transfer)
      final jsonResponse = {
        "transactionId": "trans-123",
        "householdId": "household-456",
        "household": {},
        "scrapCollectorId": "collector-789",
        "scrapCollector": {},
        "offerId": "offer-123",
        "status": "Completed",
        "scheduledTime": "2025-12-10T14:00:00Z",
        "checkInTime": "2025-12-10T14:05:00Z",
        "createdAt": "2025-12-09T15:00:00Z",
        "updatedAt": "2025-12-10T14:30:00Z",
        "transactionDetails": [
          {
            "transactionId": "trans-123",
            "scrapCategoryId": 1,
            "scrapCategory": {"scrapCategoryId": 1, "name": "Nhựa PET", "unit": "kg"},
            "pricePerUnit": 5.5,
            "unit": "kg",
            "quantity": 48.5,
            "finalPrice": 266.75
          }
        ],
        "totalPrice": 266.75
      };

      // When
      final model = TransactionModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Transaction đã Completed
      expect(entity.status, 'Completed');
      expect(entity.totalPrice, 266.75);
    });
  });
}


