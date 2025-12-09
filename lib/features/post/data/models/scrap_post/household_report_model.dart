import 'package:GreenConnectMobile/features/post/domain/entities/household_report_entity.dart';

class HouseholdReportModel {
  final int pointBalance;
  final int earnPointFromPosts;
  final int totalMyPosts;
  final List<PostStatusModelData> postModels;

  HouseholdReportModel({
    required this.pointBalance,
    required this.earnPointFromPosts,
    required this.totalMyPosts,
    required this.postModels,
  });

  factory HouseholdReportModel.fromJson(Map<String, dynamic> json) {
    return HouseholdReportModel(
      pointBalance: json['pointBalance'] ?? 0,
      earnPointFromPosts: json['earnPointFromPosts'] ?? 0,
      totalMyPosts: json['totalMyPosts'] ?? 0,
      postModels: (json['postModels'] as List<dynamic>?)
              ?.map((e) => PostStatusModelData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pointBalance': pointBalance,
      'earnPointFromPosts': earnPointFromPosts,
      'totalMyPosts': totalMyPosts,
      'postModels': postModels.map((e) => e.toJson()).toList(),
    };
  }

  HouseholdReportEntity toEntity() {
    return HouseholdReportEntity(
      pointBalance: pointBalance,
      earnPointFromPosts: earnPointFromPosts,
      totalMyPosts: totalMyPosts,
      postModels: postModels.map((e) => e.toEntity()).toList(),
    );
  }
}

class PostStatusModelData {
  final String postStatus;
  final int totalPosts;

  PostStatusModelData({
    required this.postStatus,
    required this.totalPosts,
  });

  factory PostStatusModelData.fromJson(Map<String, dynamic> json) {
    return PostStatusModelData(
      postStatus: json['postStatus'] ?? '',
      totalPosts: json['totalPosts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postStatus': postStatus,
      'totalPosts': totalPosts,
    };
  }

  PostStatusModel toEntity() {
    return PostStatusModel(
      postStatus: postStatus,
      totalPosts: totalPosts,
    );
  }
}
