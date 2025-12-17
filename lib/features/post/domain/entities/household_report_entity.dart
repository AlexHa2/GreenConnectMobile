class HouseholdReportEntity {
  final int pointBalance;
  final int earnPointFromPosts;
  final int totalMyPosts;
  final List<PostStatusModel> postModels;

  HouseholdReportEntity({
    required this.pointBalance,
    required this.earnPointFromPosts,
    required this.totalMyPosts,
    required this.postModels,
  });
}

class PostStatusModel {
  final String postStatus;
  final int totalPosts;

  PostStatusModel({
    required this.postStatus,
    required this.totalPosts,
  });
}
