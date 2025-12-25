import 'package:GreenConnectMobile/features/post/data/models/scrap_post/location_model.dart';

class UpdateRecurringScheduleModel {
  final String title;
  final String description;
  final String address;
  final LocationModel location;
  final bool mustTakeAll;
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  UpdateRecurringScheduleModel({
    required this.title,
    required this.description,
    required this.address,
    required this.location,
    required this.mustTakeAll,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'address': address,
      'location': location.toJson(),
      'mustTakeAll': mustTakeAll,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

