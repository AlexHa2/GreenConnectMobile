// scrap_post_model.dart

import 'package:GreenConnectMobile/features/household/data/models/scrap_post/household_model.dart';
import 'package:GreenConnectMobile/features/household/data/models/scrap_post/scrap_post_detail_model.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/location_entity.dart';
import 'package:GreenConnectMobile/features/household/domain/entities/scrap_post_entity.dart';

class ScrapPostModel {
  final String scrapPostId;
  final String title;
  final String description;
  final String address;
  final String availableTimeRange;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String householdId;
  final HouseholdModel? household;
  final bool mustTakeAll;
  final List<ScrapPostDetailModel> scrapPostDetails;

  ScrapPostModel({
    required this.scrapPostId,
    required this.title,
    required this.description,
    required this.address,
    required this.availableTimeRange,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.householdId,
    required this.household,
    required this.mustTakeAll,
    required this.scrapPostDetails,
  });

  factory ScrapPostModel.fromJson(Map<String, dynamic> json) {
    return ScrapPostModel(
      scrapPostId: json['scrapPostId'],
      title: json['title'],
      description: json['description'],
      address: json['address'] ?? '',
      availableTimeRange: json['availableTimeRange'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      householdId: json['householdId'],
      household: json['household'] != null
          ? HouseholdModel.fromJson(json['household'])
          : null,
      mustTakeAll: json['mustTakeAll'] ?? false,
      scrapPostDetails: (json['scrapPostDetails'] as List? ?? [])
          .map((e) => ScrapPostDetailModel.fromJson(e))
          .toList(),
    );
  }

  ScrapPostEntity toEntity() {
    return ScrapPostEntity(
      scrapPostId: scrapPostId,
      title: title,
      description: description,
      address: address,
      availableTimeRange: availableTimeRange,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
      mustTakeAll: mustTakeAll,
      household: household?.toEntity(),
      location: LocationEntity(longitude: 0, latitude: 0),
      scrapPostDetails: scrapPostDetails.map((e) => e.toEntity()).toList(),
    );
  }
}
