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
          "phoneNumber": "+84987654321",
        },
        "mustTakeAll": false,
        "scrapPostDetails": [
          {
            "scrapCategoryId": "1",
            "scrapCategory": {
              "scrapCategoryId": "1",
              "name": "Nhựa PET",
              "unit": "kg",
            },
            "amountDescription": "Khoảng 50kg",
            "imageUrl": "https://example.com/image1.jpg",
            "status": "Available",
          },
          {
            "scrapCategoryId": "2",
            "scrapCategory": {
              "scrapCategoryId": "2",
              "name": "Nhựa HDPE",
              "unit": "kg",
            },
            "amountDescription": "Khoảng 30kg",
            "imageUrl": "https://example.com/image2.jpg",
            "status": "Available",
          }
        ],
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
      expect(entity.scrapPostDetails[0].scrapCategory?.categoryName, 'Nhựa PET');
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
        "scrapPostDetails": [],
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
