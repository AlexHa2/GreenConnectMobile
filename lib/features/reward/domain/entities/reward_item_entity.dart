class RewardItemEntity {
  final int rewardItemId;
  final String itemName;
  final String description;
  final int pointsCost;
  final String imageUrl;
  final String type; // "Credit" or "Package"
  final String value;

  RewardItemEntity({
    required this.rewardItemId,
    required this.itemName,
    required this.description,
    required this.pointsCost,
    required this.imageUrl,
    required this.type,
    required this.value,
  });
}
