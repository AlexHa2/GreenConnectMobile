import 'package:GreenConnectMobile/features/post/data/models/scrap_post/location_model.dart';
import 'package:GreenConnectMobile/features/recurring_schedule/data/models/recurring_schedule/schedule_detail_model.dart';

class CreateRecurringScheduleModel {
  final String title;
  final String description;
  final String address;
  final LocationModel location;
  final bool mustTakeAll;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final List<ScheduleDetailModel> scheduleDetails;

  CreateRecurringScheduleModel({
    required this.title,
    required this.description,
    required this.address,
    required this.location,
    required this.mustTakeAll,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.scheduleDetails,
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
      'scheduleDetails': scheduleDetails
          .map((e) => {
                'scrapCategoryId': e.scrapCategoryId,
                'quantity': e.quantity ?? 0,
                'unit': e.unit,
                'amountDescription': e.amountDescription,
                'type': e.type ?? 'Sale',
              },)
          .toList(),
    };
  }
}

