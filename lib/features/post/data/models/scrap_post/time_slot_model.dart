// time_slot_model.dart
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';

class TimeSlotModel {
  final String id;
  final String specificDate;
  final String startTime;
  final String endTime;
  final bool isBooked;
  final String scrapPostId;

  TimeSlotModel({
    required this.id,
    required this.specificDate,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    required this.scrapPostId,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id']?.toString() ?? '',
      specificDate: json['specificDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isBooked: json['isBooked'] ?? false,
      scrapPostId: json['scrapPostId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specificDate': specificDate,
      'startTime': startTime,
      'endTime': endTime,
      'isBooked': isBooked,
      'scrapPostId': scrapPostId,
    };
  }

  ScrapPostTimeSlotEntity toEntity() {
    return ScrapPostTimeSlotEntity(
      id: id.isNotEmpty ? id : null,
      specificDate: specificDate,
      startTime: startTime,
      endTime: endTime,
      isBooked: isBooked,
      scrapPostId: scrapPostId.isNotEmpty ? scrapPostId : null,
    );
  }
}

