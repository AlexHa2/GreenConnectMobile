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
            scrapCategoryId: '1', // Nhựa PET
            pricePerUnit: 5.5, // 5.5k/kg
            unit: 'kg',
          ),
          OfferDetailRequest(
            scrapCategoryId: '2', // Nhựa HDPE
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
      expect(json['offerDetails'][0]['scrapCategoryId'], '1');
      expect(json['offerDetails'][0]['pricePerUnit'], 5.5);
      expect(json['offerDetails'][0]['unit'], 'kg');
      expect(json['offerDetails'][1]['scrapCategoryId'], '2');
      expect(json['offerDetails'][1]['pricePerUnit'], 4.0);
      
      expect(json['scheduleProposal']['responseMessage'], 
          'Tôi có thể đến thu gom vào lúc 14:00 ngày mai',);
      expect(json['scheduleProposal']['proposedTime'], contains('2025-12-10'));
    });

    test('should handle single offer detail', () {
      // Given - Collector chỉ offer 1 loại phế liệu
      final entity = CreateOfferRequestEntity(
        offerDetails: [
          OfferDetailRequest(
            scrapCategoryId: '1',
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
