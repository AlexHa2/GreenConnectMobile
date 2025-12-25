
import 'package:GreenConnectMobile/core/enum/offer_status.dart';
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
        status: ScheduleProposalStatus.pending,
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