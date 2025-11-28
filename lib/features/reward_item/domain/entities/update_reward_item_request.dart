class UpdateRewardItemRequest {
  final String? itemName;
  final String? description;
  final int? pointsCost;

  UpdateRewardItemRequest({
    this.itemName,
    this.description,
    this.pointsCost,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (itemName != null) {
      data['itemName'] = itemName;
    }
    if (description != null) {
      data['description'] = description;
    }
    if (pointsCost != null) {
      data['pointsCost'] = pointsCost;
    }
    return data;
  }
}
