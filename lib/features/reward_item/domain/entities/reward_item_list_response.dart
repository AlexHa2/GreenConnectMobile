import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_entity.dart';

class RewardItemListResponse {
  final List<RewardItemEntity> data;
  final PaginationInfo pagination;

  RewardItemListResponse({
    required this.data,
    required this.pagination,
  });
}

class PaginationInfo {
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginationInfo({
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });
}
