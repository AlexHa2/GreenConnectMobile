class CreateRewardItemRequest {
  final String itemName;
  final String description;
  final int pointsCost;

  CreateRewardItemRequest({
    required this.itemName,
    required this.description,
    required this.pointsCost,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'description': description,
      'pointsCost': pointsCost,
    };
  }
}
