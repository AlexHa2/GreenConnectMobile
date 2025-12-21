import 'package:GreenConnectMobile/features/post/data/models/scrap_post/scrap_post_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScrapPostModel JSON Parsing - Collector View Post Flow', () {
    test('should parse scrap post correctly for collector to view', () {
      // Given - Collector xem bài post để quyết định có offer không
      final jsonResponse = {
        "scrapPostId": "post-123",
        "title": "Bán phế liệu nhựa",
        "description": "Cần bán phế liệu nhựa số lượng lớn",
        "address": "123 Đường ABC, Quận 1, TP.HCM",
        "availableTimeRange": "8:00 - 17:00",
        "status": "Active",
        "createdAt": "2025-12-09T10:00:00Z",
        "updatedAt": "2025-12-09T11:00:00Z",
        "householdId": "household-456",
        "household": {
          "id": "household-456",
          "fullName": "Nguyễn Văn A",
          "phoneNumber": "+84987654321"
        },
        "mustTakeAll": false,
        "scrapPostDetails": [
          {
            "scrapCategoryId": 1,
            "scrapCategory": {
              "scrapCategoryId": 1,
              "name": "Nhựa PET",
              "unit": "kg"
            },
            "amountDescription": "Khoảng 50kg",
            "imageUrl": "https://example.com/image1.jpg",
            "status": "Available"
          },
          {
            "scrapCategoryId": 2,
            "scrapCategory": {
              "scrapCategoryId": 2,
              "name": "Nhựa HDPE",
              "unit": "kg"
            },
            "amountDescription": "Khoảng 30kg",
            "imageUrl": "https://example.com/image2.jpg",
            "status": "Available"
          }
        ]
      };

      // When - Collector xem bài post
      final model = ScrapPostModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Verify collector có thể xem đầy đủ thông tin để quyết định offer
      expect(entity.scrapPostId, 'post-123');
      expect(entity.title, 'Bán phế liệu nhựa');
      expect(entity.address, '123 Đường ABC, Quận 1, TP.HCM');
      expect(entity.availableTimeRange, '8:00 - 17:00');
      expect(entity.status, 'Active');
      expect(entity.mustTakeAll, false);
      expect(entity.scrapPostDetails.length, 2);
      expect(entity.scrapPostDetails[0].scrapCategory?.name, 'Nhựa PET');
      expect(entity.scrapPostDetails[0].amountDescription, 'Khoảng 50kg');
      expect(entity.household?.fullName, 'Nguyễn Văn A');
    });

    test('should handle null optional fields', () {
      // Given
      final jsonResponse = {
        "scrapPostId": "post-123",
        "title": "Test Post",
        "description": "Test",
        "address": "",
        "status": "Active",
        "createdAt": "2025-12-09T10:00:00Z",
        "mustTakeAll": false,
        "scrapPostDetails": []
      };

      // When
      final model = ScrapPostModel.fromJson(jsonResponse);

      // Then
      expect(model.availableTimeRange, null);
      expect(model.updatedAt, null);
      expect(model.householdId, null);
      expect(model.household, null);
    });
  });
}
```

```dart:test/features/collector/data/models/create_offer_request_model_test.dart
import 'package:GreenConnectMobile/features/offer/data/models/create_offer_request_model.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreateOfferRequestModel - Collector Tạo Offer Flow', () {
    test('should convert entity to JSON correctly for creating offer', () {
      // Given - Collector tạo offer sau khi xem bài post
      final entity = CreateOfferRequestEntity(
        offerDetails: [
          OfferDetailRequest(
            scrapCategoryId: 1, // Nhựa PET
            pricePerUnit: 5.5, // 5.5k/kg
            unit: 'kg',
          ),
          OfferDetailRequest(
            scrapCategoryId: 2, // Nhựa HDPE
            pricePerUnit: 4.0, // 4k/kg
            unit: 'kg',
          ),
        ],
        scheduleProposal: ScheduleProposalRequest(
          proposedTime: DateTime.parse('2025-12-10T14:00:00Z'),
          responseMessage: 'Tôi có thể đến thu gom vào lúc 14:00 ngày mai',
        ),
      );

      // When - Collector gửi offer
      final model = CreateOfferRequestModel.fromEntity(entity);
      final json = model.toJson();

      // Then - Verify offer request được format đúng
      expect(json['offerDetails'], isA<List>());
      expect(json['offerDetails'].length, 2);
      expect(json['offerDetails'][0]['scrapCategoryId'], 1);
      expect(json['offerDetails'][0]['pricePerUnit'], 5.5);
      expect(json['offerDetails'][0]['unit'], 'kg');
      expect(json['offerDetails'][1]['scrapCategoryId'], 2);
      expect(json['offerDetails'][1]['pricePerUnit'], 4.0);
      
      expect(json['scheduleProposal']['responseMessage'], 
          'Tôi có thể đến thu gom vào lúc 14:00 ngày mai');
      expect(json['scheduleProposal']['proposedTime'], contains('2025-12-10'));
    });

    test('should handle single offer detail', () {
      // Given - Collector chỉ offer 1 loại phế liệu
      final entity = CreateOfferRequestEntity(
        offerDetails: [
          OfferDetailRequest(
            scrapCategoryId: 1,
            pricePerUnit: 6.0,
            unit: 'kg',
          ),
        ],
        scheduleProposal: ScheduleProposalRequest(
          proposedTime: DateTime.now(),
          responseMessage: 'Test message',
        ),
      );

      // When
      final model = CreateOfferRequestModel.fromEntity(entity);
      final json = model.toJson();

      // Then
      expect(json['offerDetails'].length, 1);
      expect(json['offerDetails'][0]['pricePerUnit'], 6.0);
    });
  });
}
```

```dart:test/features/collector/data/models/schedule_proposal_model_test.dart
import 'package:GreenConnectMobile/features/offer/data/models/schedule_proposal_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScheduleProposalModel - Collector Hẹn Lịch Flow', () {
    test('should parse schedule proposal correctly when household accepts', () {
      // Given - Household chấp nhận lịch hẹn
      final jsonResponse = {
        "scheduleProposalId": "schedule-123",
        "collectionOfferId": "offer-456",
        "collectionOffer": null,
        "proposedTime": "2025-12-10T14:00:00Z",
        "status": "Accepted",
        "createdAt": "2025-12-09T10:00:00Z",
        "responseMessage": "Tôi có thể đến thu gom vào lúc 14:00"
      };

      // When
      final model = ScheduleProposalModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Lịch được chấp nhận, collector có thể check-in
      expect(entity.scheduleProposalId, 'schedule-123');
      expect(entity.collectionOfferId, 'offer-456');
      expect(entity.responseMessage, 'Tôi có thể đến thu gom vào lúc 14:00');
      expect(entity.status.toString(), contains('Accepted'));
      expect(entity.proposedTime, DateTime.parse('2025-12-10T14:00:00Z'));
    });

    test('should parse schedule proposal correctly when household rejects', () {
      // Given - Household từ chối lịch hẹn, collector cần đổi lịch khác
      final jsonResponse = {
        "scheduleProposalId": "schedule-123",
        "collectionOfferId": "offer-456",
        "collectionOffer": null,
        "proposedTime": "2025-12-10T14:00:00Z",
        "status": "Rejected",
        "createdAt": "2025-12-09T10:00:00Z",
        "responseMessage": "Thời gian này không phù hợp"
      };

      // When
      final model = ScheduleProposalModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then - Lịch bị từ chối, collector cần đề xuất lịch mới
      expect(entity.status.toString(), contains('Rejected'));
      expect(entity.responseMessage, 'Thời gian này không phù hợp');
    });

    test('should parse schedule proposal correctly when pending', () {
      // Given - Lịch đang chờ household phản hồi
      final jsonResponse = {
        "scheduleProposalId": "schedule-123",
        "collectionOfferId": "offer-456",
        "proposedTime": "2025-12-10T14:00:00Z",
        "status": "Pending",
        "createdAt": "2025-12-09T10:00:00Z",
        "responseMessage": "Đề xuất lịch hẹn mới"
      };

      // When
      final model = ScheduleProposalModel.fromJson(jsonResponse);
      final entity = model.toEntity();

      // Then
      expect(entity.status.toString(), contains('Pending'));
    });

    test('should convert to JSON correctly for creating new schedule proposal', () {
      // Given - Collector tạo lịch hẹn mới sau khi bị từ chối
      final model = ScheduleProposalModel(
        scheduleProposalId: 'schedule-456',
        collectionOfferId: 'offer-456',
        proposedTime: DateTime.parse('2025-12-11T15:00:00Z'),
        status: ScheduleProposalStatus.Pending,
        createdAt: DateTime.now(),
        responseMessage: 'Đề xuất lịch hẹn mới: 15:00 ngày 11/12',
      );

      // When
      final json = model.toJson();

      // Then
      expect(json['scheduleProposalId'], 'schedule-456');
      expect(json['collectionOfferId'], 'offer-456');
      expect(json['responseMessage'], 'Đề xuất lịch hẹn mới: 15:00 ngày 11/12');
      expect(json['proposedTime'], contains('2025-12-11'));
    });
  });
}
```

```dart:test/features/collector/data/models/check_in_request_test.dart
import 'package:GreenConnectMobile/features/transaction/domain/entities/check_in_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CheckInRequest - Collector Check-In Flow', () {
    test('should convert to JSON correctly for check-in', () {
      // Given - Collector đến địa điểm và check-in với GPS location
      final request = CheckInRequest(
        latitude: 10.762622, // Tọa độ TP.HCM
        longitude: 106.660172,
      );

      // When - Collector check-in
      final json = request.toJson();

      // Then - Verify GPS coordinates được gửi đúng
      expect(json['latitude'], 10.762622);
      expect(json['longitude'], 106.660172);
    });

    test('should handle different GPS coordinates', () {
      // Given - Collector ở vị trí khác
      final request = CheckInRequest(
        latitude: 21.028511,
        longitude: 105.804817, // Hà Nội
      );

      // When
      final json = request.toJson();

      // Then
      expect(json['latitude'], 21.028511);
      expect(json['longitude'], 105.804817);
    });
  });
}
```

```dart:test/features/collector/data/models/transaction_detail_request_test.dart
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionDetailRequest - Collector Ghi Số Lượng Flow', () {
    test('should convert to JSON correctly for recording quantities', () {
      // Given - Collector đã check-in và đang ghi số lượng thực tế thu gom được
      final details = [
        TransactionDetailRequest(
          scrapCategoryId: 1, // Nhựa PET
          pricePerUnit: 5.5, // Giá đã offer
          unit: 'kg',
          quantity: 48.5, // Số lượng thực tế (ít hơn dự kiến 50kg)
        ),
        TransactionDetailRequest(
          scrapCategoryId: 2, // Nhựa HDPE
          pricePerUnit: 4.0,
          unit: 'kg',
          quantity: 32.0, // Số lượng thực tế (nhiều hơn dự kiến 30kg)
        ),
      ];

      // When - Collector ghi số lượng
      final jsonList = details.map((d) => d.toJson()).toList();

      // Then - Verify số lượng được ghi đúng
      expect(jsonList.length, 2);
      expect(jsonList[0]['scrapCategoryId'], 1);
      expect(jsonList[0]['pricePerUnit'], 5.5);
      expect(jsonList[0]['unit'], 'kg');
      expect(jsonList[0]['quantity'], 48.5);
      
      expect(jsonList[1]['scrapCategoryId'], 2);
      expect(jsonList[1]['quantity'], 32.0);
    });

    test('should handle zero quantity', () {
      // Given - Collector không thu gom được loại này
      final detail = TransactionDetailRequest(
        scrapCategoryId: 3,
        pricePerUnit: 3.0,
        unit: 'kg',
        quantity: 0.0,
      );

      // When
      final json = detail.toJson();

      // Then
      expect(json['quantity'], 0.0);
    });

    test('should handle decimal quantities', () {
      // Given - Số lượng có phần thập phân
      final detail = TransactionDetailRequest(
        scrapCategoryId: 1,
        pricePerUnit: 5.5,
        unit: 'kg',
        quantity: 12.75, // 12.75 kg
      );

      // When
      final json = detail.toJson();

      // Then
      expect(json['quantity'], 12.75);
    });
  });
}
```

```dart:test/features/collector/data/models/transaction_model_test.dart
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
```

Tóm tắt các file test đã tạo theo đúng flow của collector:

1. ✅ ScrapPostModel Test — Xem bài post
2. ✅ CreateOfferRequestModel Test — Tạo offer
3. ✅ ScheduleProposalModel Test — Hẹn lịch (accept/reject/pending)
4. ✅ TransactionModel Test — Xác nhận lịch → Check-in → Ghi số lượng → Thanh toán
5. ✅ CheckInRequest Test — Collector check-in với GPS
6. ✅ TransactionDetailRequest Test — Ghi số lượng thực tế

Các test này bao phủ toàn bộ flow từ A–Z:
- Xem bài post → Tạo offer → Hẹn lịch → Xác nhận lịch → Check-in → Ghi số lượng → Thanh toán (cash/bank transfer)

Tất cả test đều theo pattern tương tự như `feedback_model_test.dart` và `collector_report_model_test.dart`.
