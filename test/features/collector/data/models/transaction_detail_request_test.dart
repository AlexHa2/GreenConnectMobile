import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionDetailRequest - Collector Ghi Số Lượng Flow', () {
    test('should convert to JSON correctly for recording quantities', () {
      // Given - Collector đã check-in và đang ghi số lượng thực tế thu gom được
      final details = [
        TransactionDetailRequest(
          scrapCategoryId: '1', // Nhựa PET
          pricePerUnit: 5.5, // Giá đã offer
          unit: 'kg',
          quantity: 48.5, // Số lượng thực tế (ít hơn dự kiến 50kg)
        ),
        TransactionDetailRequest(
          scrapCategoryId: '2', // Nhựa HDPE
          pricePerUnit: 4.0,
          unit: 'kg',
          quantity: 32.0, // Số lượng thực tế (nhiều hơn dự kiến 30kg)
        ),
      ];

      // When - Collector ghi số lượng
      final jsonList = details.map((d) => d.toJson()).toList();

      // Then - Verify số lượng được ghi đúng
      expect(jsonList.length, 2);
      expect(jsonList[0]['scrapCategoryId'], '1');
      expect(jsonList[0]['pricePerUnit'], 5.5);
      expect(jsonList[0]['unit'], 'kg');
      expect(jsonList[0]['quantity'], 48.5);
      
      expect(jsonList[1]['scrapCategoryId'], '2');
      expect(jsonList[1]['quantity'], 32.0);
    });

    test('should handle zero quantity', () {
      // Given - Collector không thu gom được loại này
      final detail = TransactionDetailRequest(
        scrapCategoryId: '3',
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
        scrapCategoryId: '1',
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
