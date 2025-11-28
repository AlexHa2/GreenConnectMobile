import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_entity.dart';

class RewardItemModel {
  final int rewardItemId;
  final String itemName;
  final String description;
  final int pointsCost;

  RewardItemModel({
    required this.rewardItemId,
    required this.itemName,
    required this.description,
    required this.pointsCost,
  });

  factory RewardItemModel.fromJson(Map<String, dynamic> json) {
    return RewardItemModel(
      rewardItemId: json['rewardItemId'] ?? 0,
      itemName: json['itemName'] ?? '',
      description: json['description'] ?? '',
      pointsCost: json['pointsCost'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rewardItemId': rewardItemId,
      'itemName': itemName,
      'description': description,
      'pointsCost': pointsCost,
    };
  }

  RewardItemEntity toEntity() {
    return RewardItemEntity(
      rewardItemId: rewardItemId,
      itemName: itemName,
      description: description,
      pointsCost: pointsCost,
    );
  }
}
