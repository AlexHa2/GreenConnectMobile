class RewardHistoryEntity {
  final int rewardItemId;
  final String itemName;
  final String description;
  final int pointsSpent;
  final DateTime redemptionDate;
  final String imageUrl;

  RewardHistoryEntity({
    required this.rewardItemId,
    required this.itemName,
    required this.description,
    required this.pointsSpent,
    required this.redemptionDate,
    required this.imageUrl,
  });
}
