import 'package:GreenConnectMobile/features/household/data/models/household_model.dart';
import 'package:GreenConnectMobile/features/household/data/models/location_model.dart';
import 'package:GreenConnectMobile/features/household/data/models/scrap_post_detail_model.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_entity.dart';

class ScrapPostModel extends ScrapPostEntity {
  ScrapPostModel({
    required super.scrapPostId,
    required super.title,
    required super.description,
    required super.address,
    required super.availableTimeRange,
    required super.status,
    required super.updatedAt,
    required super.createdAt,
    required super.householdId,
    required super.household,
    required super.location,
    required super.mustTakeAll,
    required super.scrapPostDetails,
  });

  factory ScrapPostModel.fromJson(Map<String, dynamic> json) {
    return ScrapPostModel(
      scrapPostId: json['scrapPostId'],
      title: json['title'],
      description: json['description'],
      address: json['address'],
      availableTimeRange: json['availableTimeRange'],
      status: json['status'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      householdId: json['householdId'],
      household: json['household'] != null
          ? HouseholdModel.fromJson(json['household'])
          : null,
      location: LocationModel.fromJson(json['location']),
      mustTakeAll: json['mustTakeAll'],
      scrapPostDetails: (json['scrapPostDetails'] as List)
          .map((e) => ScrapPostDetailModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'address': address,
    'availableTimeRange': availableTimeRange,
    'updatedAt': updatedAt,
    'location': (location as LocationModel).toJson(),
    'mustTakeAll': mustTakeAll,
    'scrapPostDetails': scrapPostDetails
        .map((e) => (e as ScrapPostDetailModel).toJson())
        .toList(),
  };

  ScrapPostEntity toEntity() {
    return ScrapPostEntity(
      scrapPostId: scrapPostId,
      title: title,
      description: description,
      address: address,
      availableTimeRange: availableTimeRange,
      status: status,
      updatedAt: updatedAt,
      createdAt: createdAt,
      householdId: householdId,
      household: household != null
          ? (household as HouseholdModel).toEntity()
          : null,
      location: (location as LocationModel).toEntity(),
      mustTakeAll: mustTakeAll,
      scrapPostDetails: scrapPostDetails
          .map((e) => (e as ScrapPostDetailModel).toEntity())
          .toList(),
    );
  }
}
