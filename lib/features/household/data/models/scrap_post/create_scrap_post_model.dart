// create_scrap_post_model.dart
import 'package:GreenConnectMobile/features/household/data/models/scrap_post/location_model.dart';

class CreateScrapPostModel {
  final String title;
  final String description;
  final String address;
  final String availableTimeRange;
  final LocationModel location;
  final bool mustTakeAll;
  final List<CreateScrapPostDetailModel> scrapPostDetails;

  CreateScrapPostModel({
    required this.title,
    required this.description,
    required this.address,
    required this.availableTimeRange,
    required this.location,
    required this.mustTakeAll,
    required this.scrapPostDetails,
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
    };
  }
}

class CreateScrapPostDetailModel {
  final int scrapCategoryId;
  final String amountDescription;
  final String imageUrl;

  CreateScrapPostDetailModel({
    required this.scrapCategoryId,
    required this.amountDescription,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "scrapCategoryId": scrapCategoryId,
      "amountDescription": amountDescription,
      "imageUrl": imageUrl,
    };
  }
}
