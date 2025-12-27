// create_scrap_post_model.dart
import 'package:GreenConnectMobile/features/post/data/models/scrap_post/location_model.dart';

class CreateScrapPostModel {
  final String title;
  final String description;
  final String address;
  final String availableTimeRange;
  final LocationModel location;
  final bool mustTakeAll;
  final List<CreateScrapPostDetailModel> scrapPostDetails;
  final List<CreateScrapPostTimeSlotModel> scrapPostTimeSlots;

  CreateScrapPostModel({
    required this.title,
    required this.description,
    required this.address,
    required this.availableTimeRange,
    required this.location,
    required this.mustTakeAll,
    required this.scrapPostDetails,
    this.scrapPostTimeSlots = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "address": address,
      "availableTimeRange": availableTimeRange,
      "location": location.toJson(),
      "mustTakeAll": mustTakeAll,
      "scrapPostDetails": scrapPostDetails.map((e) => e.toJson()).toList(),
      "scrapPostTimeSlots": scrapPostTimeSlots.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateScrapPostTimeSlotModel {
  final String specificDate;
  final String startTime;
  final String endTime;

  CreateScrapPostTimeSlotModel({
    required this.specificDate,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "specificDate": specificDate,
      "startTime": startTime,
      "endTime": endTime,
    };
  }
}

class CreateScrapPostDetailModel {
  final String scrapCategoryId;
  final String amountDescription;
  final String? imageUrl;
  final String? type;

  CreateScrapPostDetailModel({
    required this.scrapCategoryId,
    required this.amountDescription,
    this.imageUrl,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "scrapCategoryId": scrapCategoryId,
      "amountDescription": amountDescription,
      "imageUrl": imageUrl,
      "type": type,
    };
  }
}
