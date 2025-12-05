import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_entity.dart';

class PaginatedRewardItemEntity {
  final List<RewardItemEntity> rewardItems;
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginatedRewardItemEntity({
    required this.rewardItems,
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });

  bool get hasNextPage => nextPage != null;
  bool get hasPrevPage => prevPage != null;
}
