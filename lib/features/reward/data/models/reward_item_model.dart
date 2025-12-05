import 'package:GreenConnectMobile/features/reward/domain/entities/reward_item_entity.dart';

class RewardItemModel extends RewardItemEntity {
  RewardItemModel({
    required super.rewardItemId,
    required super.itemName,
    required super.description,
    required super.pointsCost,
    required super.imageUrl,
    required super.type,
    required super.value,
  });

  factory RewardItemModel.fromJson(Map<String, dynamic> json) {
    return RewardItemModel(
      rewardItemId: json['rewardItemId'] ?? 0,
      itemName: json['itemName'] ?? '',
      description: json['description'] ?? '',
      pointsCost: json['pointsCost'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? 'Credit',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rewardItemId': rewardItemId,
      'itemName': itemName,
      'description': description,
      'pointsCost': pointsCost,
      'imageUrl': imageUrl,
      'type': type,
      'value': value,
    };
  }

  RewardItemEntity toEntity() {
    return RewardItemEntity(
      rewardItemId: rewardItemId,
      itemName: itemName,
      description: description,
      pointsCost: pointsCost,
      imageUrl: imageUrl,
      type: type,
      value: value,
    );
  }
}
