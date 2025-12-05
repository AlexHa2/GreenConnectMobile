import 'package:GreenConnectMobile/features/reward/domain/entities/reward_history_entity.dart';

class RewardHistoryModel extends RewardHistoryEntity {
  RewardHistoryModel({
    required super.rewardItemId,
    required super.itemName,
    required super.description,
    required super.pointsSpent,
    required super.redemptionDate,
    required super.imageUrl,
  });

  factory RewardHistoryModel.fromJson(Map<String, dynamic> json) {
    return RewardHistoryModel(
      rewardItemId: json['rewardItemId'] ?? 0,
      itemName: json['itemName'] ?? '',
      description: json['description'] ?? '',
      pointsSpent: json['pointsSpent'] ?? 0,
      redemptionDate: json['redemptionDate'] != null
          ? DateTime.parse(json['redemptionDate'])
          : DateTime.now(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rewardItemId': rewardItemId,
      'itemName': itemName,
      'description': description,
      'pointsSpent': pointsSpent,
      'redemptionDate': redemptionDate.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  RewardHistoryEntity toEntity() {
    return RewardHistoryEntity(
      rewardItemId: rewardItemId,
      itemName: itemName,
      description: description,
      pointsSpent: pointsSpent,
      redemptionDate: redemptionDate,
      imageUrl: imageUrl,
    );
  }
}
